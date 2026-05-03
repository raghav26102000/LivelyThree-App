// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

class FFWheelPicker extends StatefulWidget {
  // ----- Parameters -----
  final int? min; // minimum value
  final int? max; // maximum value
  final int? step; // increment
  final int? initialValue; // starting value (for numeric mode)

  final List<String>? items; // custom string list mode
  final String? initialItem; // starting value (for string mode)

  final String suffix; // e.g., " g"

  final double? width;
  final double height;
  final double itemExtent;

  // Styling
  final double selectedFontSize;
  final double unselectedFontSize;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color selectedChipColor;
  final Color selectedChipBorderColor;
  final double selectedChipRadius;
  final double chipHPadding;
  final double chipVPadding;
  final bool haptics;

  // Wheel behavior
  final bool loop;
  final double diameterRatio;
  final double perspective;
  final double offAxisFraction;
  final double chipBorderRadius;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final List<BoxShadow>? boxShadows;

  // Callback
  final void Function(dynamic value)? onChanged;
  final void Function(dynamic value)? onTap;
  final bool loadPortionSizesFromDB;
  final Widget Function(String value)? selectedItemBuilder;

  const FFWheelPicker({
    Key? key,
    this.min,
    this.max,
    this.step,
    this.initialValue,
    this.items,
    this.initialItem,
    this.suffix = '',
    this.width,
    this.height = 254,
    this.itemExtent = 48,
    this.selectedFontSize = 26,
    this.unselectedFontSize = 18,
    this.selectedTextColor = const Color(0xFFFFFFFF),
    this.unselectedTextColor = const Color(0xFF9E9E9E),
    this.selectedChipColor = const Color(0xFF000000),
    this.selectedChipBorderColor = const Color(0xFF000000),
    this.selectedChipRadius = 28,
    this.chipHPadding = 12,
    this.chipVPadding = 6,
    this.haptics = true,
    this.loop = false,
    this.diameterRatio = 2.0,
    this.perspective = 0.003,
    this.offAxisFraction = 0.0,
    this.chipBorderRadius = 0.0,
    this.onChanged,
    this.onTap,
    this.gradientColors,
    this.gradientStops,
    this.boxShadows,
    this.loadPortionSizesFromDB = false,
    this.selectedItemBuilder,
  }) : super(key: key);

  @override
  State<FFWheelPicker> createState() => _FFWheelPickerState();
}

class _FFWheelPickerState extends State<FFWheelPicker> {
  // 🔥 FIXED: Initialize with empty list instead of using late
  List<String> _values = [];
  FixedExtentScrollController? _controller;
  String _selectedValue = '';
  bool _isLoading = true;
  String _errorMessage = '';
  bool _hasLoadedPortionSizes = false;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  Future<void> _initializeValues() async {
    // Check if we need to load from database
    if (widget.loadPortionSizesFromDB && !_hasLoadedPortionSizes) {
      if (mounted) {
        setState(() => _isLoading = true);
      }

      try {
        final dbValues = await _fetchValuesFromDatabase();
        if (mounted) {
          setState(() {
            _values = dbValues;
            _hasLoadedPortionSizes = true;
            _selectedValue = widget.initialValue?.toString() ??
                (_values.isNotEmpty ? _values.first : '10');
            _isLoading = false;
          });
          _initializeController();
        }
      } catch (e) {
        if (mounted) {
          // Use fallback values on error
          setState(() {
            _values = _getFallbackValues();
            _selectedValue = widget.initialValue?.toString() ?? _values.first;
            _isLoading = false;
            _errorMessage = 'Database fetch failed, using defaults';
          });
          _initializeController();
        }
      }
    } else {
      // Build value list normally
      if (widget.items != null && widget.items!.isNotEmpty) {
        // String mode
        _values = widget.items!;
        _selectedValue = widget.initialItem ?? _values.first;
      } else {
        // Numeric mode
        final values = <int>[];
        for (int v = widget.min ?? 0;
            v <= (widget.max ?? 100);
            v += (widget.step ?? 1)) {
          values.add(v);
        }
        _values = values.map((v) => v.toString()).toList();

        final validValue =
            _closestValidValue(widget.initialValue ?? (widget.min ?? 0));
        _selectedValue = validValue.toString();
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
      _initializeController();
    }
  }

  void _initializeController() {
    final initialIndex = _values.indexOf(_selectedValue);
    _controller = FixedExtentScrollController(
        initialItem: initialIndex >= 0 ? initialIndex : 0);
  }

  // 🔥 Method to fetch portion sizes from database
  Future<List<String>> _fetchValuesFromDatabase() async {
    try {
      final response = await Supabase.instance.client
          .from('codelkup')
          .select('key1, keycode')
          .eq('lkcode', 'portionsize_value')
          .eq('status', 1) // Only active records
          .order('keycode', ascending: true);

      print('response portion size values: $response');
      if (response != null && response.isNotEmpty) {
        final values = response
            .map<String>((item) {
              final value = item['key1'];
              if (value == null) return '';
              return value.toString();
            })
            .where((value) => value != null && value.isNotEmpty)
            .cast<String>()
            .toList();

        if (values.isNotEmpty) {
          return values;
        }
      }

      // Return fallback values if database fetch returns empty results
      return _getFallbackValues();
    } catch (e) {
      print('Error fetching values from database: $e');
      throw e; // Re-throw to be handled by caller
    }
  }

  // Get fallback values based on mode
  List<String> _getFallbackValues() {
    if (widget.items != null && widget.items!.isNotEmpty) {
      return widget.items!;
    } else {
      // Generate numeric fallback values
      final values = <int>[];
      for (int v = widget.min ?? 5;
          v <= (widget.max ?? 200);
          v += (widget.step ?? 5)) {
        values.add(v);
      }
      return values.map((v) => v.toString()).toList();
    }
  }

  int _closestValidValue(int raw) {
    final min = widget.min ?? 0;
    final max = widget.max ?? 100;
    final step = widget.step ?? 1;

    final clamped = raw.clamp(min, max);
    final delta = (clamped - min) % step;
    return clamped - delta;
  }

  // Handle tap on individual items
  void _handleItemTap(String value) {
    if (!mounted) return; //  FIXED: Check if widget is still mounted
    print('210 $value');
    // Update selected value
    setState(() => _selectedValue = value);

    // Scroll to the tapped item
    final index = _values.indexOf(value);
    if (index >= 0 && _controller != null) {
      _controller!.animateToItem(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }

    // Trigger haptics if enabled
    if (widget.haptics) HapticFeedback.selectionClick();

    // Call onTap callback
    if (widget.onTap != null) {
      if (widget.items != null) {
        widget.onTap!(value); // string mode
      } else {
        widget.onTap!(int.parse(value)); // numeric mode
      }
    }
  }

  Widget _chip(String value) {
    final isSelected = value == _selectedValue;

    // 🔥 If custom selected widget is provided
    if (isSelected && widget.selectedItemBuilder != null) {
      return Center(
        child: GestureDetector(
          onTap: () => _handleItemTap(value),
          child: widget.selectedItemBuilder!(value),
        ),
      );
    }

    // ----- Your existing code remains unchanged below -----

    final selectedIndex = widget.items?.indexOf(_selectedValue) ?? 0;
    final currentIndex = widget.items?.indexOf(value) ?? 0;
    final distance = (currentIndex - selectedIndex).abs();

    double fontSize;
    if (distance == 0) {
      fontSize = widget.selectedFontSize;
    } else if (distance == 1) {
      fontSize = widget.selectedFontSize - 3;
    } else if (distance == 2) {
      fontSize = widget.selectedFontSize - 3;
    } else {
      fontSize = widget.selectedFontSize - 3;
    }

    return Center(
      child: GestureDetector(
        onTap: () => _handleItemTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? widget.chipHPadding : 0,
            vertical: isSelected ? widget.chipVPadding : 0,
          ),
          decoration: BoxDecoration(
            color: isSelected ? widget.selectedChipColor : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.selectedChipRadius),
            border: isSelected
                ? Border.all(width: 1, color: widget.selectedChipBorderColor)
                : null,
            gradient: (widget.gradientColors != null && isSelected)
                ? LinearGradient(
                    colors: widget.gradientColors!,
                    stops: widget.gradientStops,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            boxShadow: (widget.boxShadows != null && isSelected)
                ? widget.boxShadows
                : null,
          ),
          child: RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? widget.selectedTextColor
                    : widget.unselectedTextColor,
              ),
              children: [
                if (isSelected && widget.items == null && widget.suffix != null)
                  TextSpan(
                    text: widget.suffix!,
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? widget.selectedTextColor
                          : widget.unselectedTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 FIXED: Show loading indicator while data is being fetched
    if (_isLoading || _values.isEmpty || _controller == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final children = _values.map(_chip).toList();

    final wheel = ListWheelScrollView.useDelegate(
      controller: _controller!,
      itemExtent: widget.itemExtent,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.diameterRatio,
      perspective: widget.perspective,
      offAxisFraction: widget.offAxisFraction,
      onSelectedItemChanged: (index) {
        if (!mounted) return; // 🔥 FIXED: Check if widget is still mounted

        final idx = index % _values.length;
        final newValue = _values[idx];
        if (newValue != _selectedValue) {
          setState(() => _selectedValue = newValue);
          if (widget.haptics) HapticFeedback.selectionClick();

          // Call parent callback with numeric or string
          if (widget.onChanged != null) {
            if (widget.items != null) {
              widget.onChanged!(newValue); // string mode
            } else {
              widget.onChanged!(int.parse(newValue)); // numeric mode
            }
          }
        }
      },
      childDelegate: widget.loop
          ? ListWheelChildLoopingListDelegate(children: children)
          : ListWheelChildListDelegate(children: children),
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          wheel,
          IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x10FFFFFF),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0x10FFFFFF),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

Future<List<String>> fetchPortionSizes() async {
  try {
    final response = await Supabase.instance.client
        .from('codelkup')
        .select('key1')
        .eq('lkcode', 'portionsize_value')
        .order('keycode', ascending: true);
    print('response portion size values: $response');
    if (response != null && response.isNotEmpty) {
      return response
          .map<String>((item) => item['key1'].toString())
          .where((value) => value.isNotEmpty)
          .toList();
    }

    // 🔥 FIXED: Removed syntax error in fallback values (extra comma)
    return [
      '10',
      '20',
      '30',
      '40',
      '50',
      '60',
      '70',
      '80',
      '90',
      '100',
      '110',
      '120',
      '130',
      '140',
      '150'
    ];
  } catch (e) {
    print('Error fetching portion sizes: $e');
    // 🔥 FIXED: Removed syntax error in fallback values (extra comma)
    return [
      '10',
      '20',
      '30',
      '40',
      '50',
      '60',
      '70',
      '80',
      '90',
      '100',
      '110',
      '120',
      '130',
      '140',
      '150'
    ];
  }
}
