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

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeightPicker extends StatefulWidget {
  const WeightPicker({
    super.key,
    this.width,
    this.height,
    required this.onValueChange,
    required this.initialUnit,
    required this.initialValue,
    required this.userId,
    required this.calendarWeek,
    required this.calendarYear,
    required this.currentDay,
  });

  final double? width;
  final double? height;

  /// Only triggers timestamp on submit
  final void Function(String unit, double value, DateTime timestamp)
      onValueChange;

  final String initialUnit; // 'kg' or 'lb'
  final double initialValue; // Initial weight value
  final String userId; // User ID
  final int calendarWeek; // Week of the year
  final int calendarYear; // Year
  final String currentDay; // Day of the week

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late bool isKg;
  late int selectedWhole;
  late double selectedFraction;
  late FixedExtentScrollController wholeScrollController;
  late FixedExtentScrollController fractionScrollController;

  @override
  void initState() {
    super.initState();

    isKg = widget.initialUnit == 'kg';

    double initialValue = widget.initialValue;
    selectedWhole = initialValue.floor();
    selectedFraction =
        double.parse((initialValue - selectedWhole).toStringAsFixed(1));

    wholeScrollController =
        FixedExtentScrollController(initialItem: selectedWhole);
    fractionScrollController = FixedExtentScrollController(
        initialItem: (selectedFraction * 10).toInt());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updatePickers();
      }
    });
  }

  double _convertToKg(double valueInLb) {
    return valueInLb / 2.20462; // from lb to kg
  }

  double _convertToLb(double valueInKg) {
    return valueInKg * 2.20462; // from kg to lb
  }

  void _updatePickers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        wholeScrollController.jumpToItem(selectedWhole);
        fractionScrollController.jumpToItem((selectedFraction * 10).toInt());
      }
    });
  }

  /// Called only when user presses Submit
  Future<void> _submitWeight() async {
    final supabase = Supabase.instance.client;
    final value = selectedWhole + selectedFraction;
    final unit = isKg ? 'kg' : 'lb';

    try {
      final existingRow = await supabase
          .from('user_vitals')
          .select()
          .eq('user_id', widget.userId)
          .eq('vital_type', 'Weight')
          .eq('calendarweek', widget.calendarWeek)
          .eq('calendaryear', widget.calendarYear)
          .eq('currentday', widget.currentDay)
          .maybeSingle();

      if (existingRow != null) {
        await supabase.from('user_vitals').update({
          'value': value,
          'unit': unit,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', existingRow['id']);
      } else {
        await supabase.from('user_vitals').insert({
          'user_id': widget.userId,
          'vital_type': 'Weight',
          'calendarweek': widget.calendarWeek,
          'calendaryear': widget.calendarYear,
          'currentday': widget.currentDay,
          'value': value,
          'unit': unit,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      // Only here we trigger the callback with a timestamp
      widget.onValueChange(unit, value, DateTime.now());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight submitted successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting weight: $e')),
      );
    }
  }

  @override
  void didUpdateWidget(covariant WeightPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue ||
        widget.initialUnit != oldWidget.initialUnit) {
      isKg = widget.initialUnit == 'kg';

      double newValue = widget.initialValue;
      selectedWhole = newValue.floor();
      selectedFraction =
          double.parse((newValue - selectedWhole).toStringAsFixed(1));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updatePickers();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Whole number picker
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 200,
                    height: 100,
                    child: CupertinoPicker.builder(
                      itemExtent: 36.0,
                      scrollController: wholeScrollController,
                      onSelectedItemChanged: (int index) {
                        // No callback here
                        setState(() {
                          selectedWhole = index;
                        });
                      },
                      childCount: 1000,
                      itemBuilder: (context, index) {
                        final isMainItem = index == selectedWhole;
                        return Center(
                          child: Text(
                            index.toString(),
                            style: TextStyle(
                              fontSize: isMainItem
                                  ? FlutterFlowTheme.adjustScale(size: 22.0)
                                  : FlutterFlowTheme.adjustScale(size: 20.0),
                              color: isMainItem
                                  ? Colors.black
                                  : Colors.grey.shade400,
                              fontWeight: isMainItem
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Spacing + Dot + Spacing
                const SizedBox(width: 4),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '.',
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 22.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Fraction picker
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: CupertinoPicker.builder(
                      itemExtent: 36.0,
                      scrollController: fractionScrollController,
                      onSelectedItemChanged: (int index) {
                        // No callback here
                        setState(() {
                          selectedFraction = index / 10;
                        });
                      },
                      childCount: 10,
                      itemBuilder: (context, index) {
                        final isMainItem =
                            index == (selectedFraction * 10).toInt();
                        return Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: isMainItem
                                  ? FlutterFlowTheme.adjustScale(size: 22.0)
                                  : FlutterFlowTheme.adjustScale(size: 20.0),
                              color: isMainItem
                                  ? Colors.black
                                  : Colors.grey.shade400,
                              fontWeight: isMainItem
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                VerticalDivider(
                  color: Colors.grey.shade400,
                  width: 1.0,
                  thickness: 1.0,
                ),

                // Submit button with increased curvature
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // radius => 8
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitWeight,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
