// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class SettingsSelectionChoiceChip extends StatefulWidget {
  const SettingsSelectionChoiceChip({
    Key? key,
    // Database identification
    required this.idLoc,
    required this.plantName,
    required this.color,
    required this.week,
    required this.year,
    required this.userId,

    // Pre-fetched “selected” state
    required this.isSelected,
    required this.portionSum,
    required this.portionSize,

    // Visual styling
    required this.colorTextUntapped,
    required this.colorTextTapped,
    required this.colorChoiceChipUntapped,
    required this.colorChoiceChipTapped,
    required this.borderColorUntapped,
    required this.borderColorTapped,
    required this.shadowColorUntapped,
    required this.shadowColorTapped,
    required this.listAreaUntapped,
    required this.listAreaTapped,

    // Optional size hints
    this.width,
    this.height,

    // Screen size for responsiveness
    this.screenSize = 'medium', // "small" | "medium" | "large"

    // Existing callbacks
    this.onRightSideTap,
    this.onCannotRemoveNonZeroPortion,

    // NEW callback: only returns int => the updated number of selected plants for this color
    this.onSelectionCountUpdated,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String screenSize;

  // DB row references
  final int idLoc;
  final String plantName;
  final String color;
  final int week;
  final int year;
  final String userId;

  // Pre-fetched “isSelected” logic
  final bool isSelected;
  final double portionSum;
  final double portionSize;

  // Visual styling
  final Color colorTextUntapped;
  final Color colorTextTapped;
  final Color colorChoiceChipUntapped;
  final Color colorChoiceChipTapped;
  final Color borderColorUntapped;
  final Color borderColorTapped;
  final Color shadowColorUntapped;
  final Color shadowColorTapped;
  final Color listAreaUntapped;
  final Color listAreaTapped;

  // Existing callbacks
  final VoidCallback? onRightSideTap;
  final VoidCallback? onCannotRemoveNonZeroPortion;

  /// Callback invoked after toggling. We supply only `int newCount`.
  final ValueChanged<int>? onSelectionCountUpdated;

  @override
  State<SettingsSelectionChoiceChip> createState() =>
      _SettingsSelectionChoiceChipState();
}

class _SettingsSelectionChoiceChipState
    extends State<SettingsSelectionChoiceChip> {
  final supabase = Supabase.instance.client;

  // Local states for the chip
  late bool _selected;
  late double _portionSum;

  // Animations
  bool _isPressed = false;
  bool _isFlashing = false;
  Timer? _delayedUiTimer;

  final Duration _animationDuration = const Duration(milliseconds: 250);
  final Duration _expansionDuration = const Duration(milliseconds: 140);

  @override
  void initState() {
    super.initState();
    _selected = widget.isSelected;
    _portionSum = widget.portionSum;
  }

  @override
  void dispose() {
    _delayedUiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1) Determine scale factor based on screenSize each build
    double f;
    switch (widget.screenSize.toLowerCase()) {
      case 'small':
        f = 0.8; // shrink to 70%
        break;
      case 'large':
        f = 1.15; // grow to 115%
        break;
      default:
        f = 1.0; // medium = 100%
    }

    debugPrint('SettingsChoiceChip scale factor f = $f');

    // 2) Derive sizes
    final fontSize = 14.0 * f;
    final iconSize = 20.0 * f;
    final padH = 8.0 * f;
    final padV = 3.0 * f;
    final listW = 36.0 * f;
    final radius = 24.0 * f;

    // 3) Colors & flashing logic
    final backgroundColor = _selected
        ? widget.colorChoiceChipTapped
        : widget.colorChoiceChipUntapped;
    final effectiveBackground = _isFlashing
        ? Color.lerp(backgroundColor, Colors.white, 0.3)!
        : backgroundColor;
    final borderColor =
        _selected ? widget.borderColorTapped : widget.borderColorUntapped;
    final textColor =
        _selected ? widget.colorTextTapped : widget.colorTextUntapped;

    return AnimatedScale(
      scale: _isPressed ? 1.1 : 1.0,
      duration: _expansionDuration,
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          minWidth: widget.width ?? 0,
          minHeight: widget.height ?? 0,
        ),
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _selected
                  ? widget.shadowColorTapped.withOpacity(0.9)
                  : widget.shadowColorUntapped.withOpacity(0.4),
              blurRadius: _selected ? 5.0 : 2.5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left: plantName
            GestureDetector(
              onTap: _handleMainTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0 * f),
                child: Text(
                  widget.plantName,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: _selected ? FontWeight.w600 : FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ),
            ),

            SizedBox(width: 6.0 * f),

            // Right: list icon
            GestureDetector(
              onTap: widget.onRightSideTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: listW,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selected
                      ? widget.listAreaTapped
                      : widget.listAreaUntapped,
                  borderRadius: BorderRadius.circular(radius),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: padH * 0.5,
                  vertical: padV,
                ),
                child: Icon(
                  Icons.list_alt,
                  size: iconSize,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle selection and update DB
  Future<void> _handleMainTap() async {
    setState(() {
      _isPressed = true;
      _isFlashing = true;
    });
    _delayedUiTimer?.cancel();
    _delayedUiTimer = Timer(
      _animationDuration + _expansionDuration,
      () {
        if (!mounted) return;
        setState(() {
          _isPressed = false;
          _isFlashing = false;
        });
      },
    );

    if (!_selected) {
      await _insertNewRow();
      setState(() {
        _selected = true;
        _portionSum = 0.0;
      });
    } else {
      if (_portionSum > 0) {
        widget.onCannotRemoveNonZeroPortion?.call();
      } else {
        await _removeRow();
        setState(() {
          _selected = false;
          _portionSum = 0.0;
        });
      }
    }

    final newCount = await _countSelectedPlantsByColor();
    widget.onSelectionCountUpdated?.call(newCount);
  }

  Future<void> _insertNewRow() async {
    try {
      await supabase.from('weeklyselectedplant').insert({
        'id_loc': widget.idLoc,
        'id_user': widget.userId,
        'week': widget.week,
        'year': widget.year,
        'plantname': widget.plantName,
        'color': widget.color,
        'portionsum': 0.0,
        'portionsize': widget.portionSize, // <-- add this
        'portionsize_locked': false, // <-- and this
        'monportion': 0,
        'tueportion': 0,
        'wedportion': 0,
        'thuportion': 0,
        'friportion': 0,
        'satportion': 0,
        'sunportion': 0,
      });
    } catch (e) {
      debugPrint("Error inserting new row: $e");
    }
  }

  Future<void> _removeRow() async {
    try {
      await supabase
          .from('weeklyselectedplant')
          .delete()
          .eq('id_loc', widget.idLoc)
          .eq('id_user', widget.userId)
          .eq('week', widget.week)
          .eq('year', widget.year);
    } catch (e) {
      debugPrint("Error removing row: $e");
    }
  }

  Future<int> _countSelectedPlantsByColor() async {
    try {
      final response = await supabase
          .from('weeklyselectedplant')
          .select('*')
          .eq('id_user', widget.userId)
          .eq('week', widget.week)
          .eq('year', widget.year)
          .eq('color', widget.color);
      return (response as List<dynamic>?)?.length ?? 0;
    } catch (e) {
      debugPrint("Error counting selected plants by color: $e");
      return 0;
    }
  }
}
