import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_lively_three/components/country_popup/country_popup_widget.dart';
import 'package:the_lively_three/components/permissions_pages/default_criteria.dart';
import 'package:the_lively_three/components/permissions_pages/medical_application_deny.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
    as custom_widgets;
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_widgets.dart';
import '/backend/supabase/supabase.dart';
import '/l10n/app_localizations.dart';

enum InputType { text, number, single_choice, date, multi }

class DynamicFormField extends StatefulWidget {
  final String title;
  final String? description;
  final String? skipText;
  final String? continueButtonText;
  final String inputType;
  final List<String>? options; // For dropdown and multi-select
  final String? placeholder;
  final bool isRequired;
  final Function(dynamic value) onChanged;
  final dynamic initialValue;
  final int totalQuestions;
  final int currentQuestions;
  final VoidCallback? onSkip;

  final String? errorText;
  final VoidCallback? onSkipAll;
  final Future<void> Function()? onNext;

  final VoidCallback? onBack;
  final bool isSkipVisible;
  final bool skipButtonBorder;
  final bool showBack;
  final bool showSkipAll;

  const DynamicFormField(
      {Key? key,
      required this.title,
      this.description,
      this.skipText,
      this.continueButtonText,
      required this.inputType,
      this.options,
      this.placeholder,
      this.isRequired = false,
      this.isSkipVisible = true,
      this.skipButtonBorder = false,
      required this.onChanged,
      this.initialValue,
      required this.totalQuestions,
      required this.currentQuestions,
      this.errorText, // 👈 Add this
      this.onNext,
      this.onBack,
      this.onSkip,
      this.onSkipAll,
      this.showSkipAll = true,
      this.showBack = false})
      : super(key: key);

  @override
  State<DynamicFormField> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  late dynamic _currentValue;
  List<Map<String, dynamic>> _countries = [];
  List<String> _selectedMultiValues = [];
  int weightValue = 50; // default number
  String weightUnit = "kg"; // default unit
  int heightValue = 170; // default cm
  int heightFeet = 5;
  int heightInches = 7;
  String heightUnit = "cm";

  void updateWeight() {
    _currentValue = "$weightValue $weightUnit";
    // 🔹 here you can setState, call API, update form field etc.
  }

  void updateHeight() {
    if (heightUnit == "cm") {
      _currentValue = "$heightValue cm";
    } else {
      _currentValue = "$heightFeet'$heightInches\"";
    }
  }

  Future<void> fetchCodeLookupValues(String lookupCode) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_codelookup_values', params: {'lookupcode': lookupCode});

      if (response != null) {
        final data = (response as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        setState(() {
          _countries = data;
        });
      } else {
        print("⚠️ No data returned for $lookupCode");
      }
    } catch (e) {
      print("❌ Error fetching codelookup values: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;

    if (widget.inputType == 'multi' && widget.initialValue is List) {
      _selectedMultiValues = List<String>.from(widget.initialValue);
    }

    // ✅ Parse WEIGHT from initialValue (e.g., "65 kg" or "143 lbs")
    if (widget.title.toLowerCase().contains('weigh') &&
        widget.initialValue != null &&
        widget.initialValue.toString().trim().isNotEmpty) {
      final valueStr = widget.initialValue.toString().trim();
      final match =
          RegExp(r'^(\d+(?:\.\d+)?)\s*([a-zA-Z]+)$').firstMatch(valueStr);

      if (match != null) {
        final numStr = match.group(1);
        final unit = match.group(2)?.toLowerCase();

        if (numStr != null) {
          // Parse as int or double, then round
          weightValue =
              int.tryParse(numStr) ?? double.tryParse(numStr)?.round() ?? 50;
          weightUnit = (unit == 'lbs' || unit == 'lb') ? 'lbs' : 'kg';
          print("✅ Restored weight: $weightValue $weightUnit from '$valueStr'");
        }
      } else {
        print("⚠️ Could not parse weight from '$valueStr'");
      }
    }

    // ✅ Parse HEIGHT from initialValue (e.g., "170 cm" or "5'7"")
    if (widget.title.toLowerCase().contains('height') &&
        widget.initialValue != null &&
        widget.initialValue.toString().trim().isNotEmpty) {
      final valueStr = widget.initialValue.toString().trim();

      // Parse "170 cm" format
      if (valueStr.contains('cm')) {
        final match = RegExp(r'^(\d+)').firstMatch(valueStr);
        if (match != null) {
          heightValue = int.tryParse(match.group(1) ?? '') ?? 170;
          heightUnit = 'cm';
          print("✅ Restored height: $heightValue cm from '$valueStr'");
        } else {
          print("⚠️ Could not parse cm height from '$valueStr'");
        }
      }
      // Parse "5'7"" format
      else if (valueStr.contains("'")) {
        final match = RegExp(r"(\d+)'(\d+)").firstMatch(valueStr);
        if (match != null) {
          heightFeet = int.tryParse(match.group(1) ?? '') ?? 5;
          heightInches = int.tryParse(match.group(2) ?? '') ?? 7;
          heightUnit = 'ft/in';
          print(
              "✅ Restored height: $heightFeet'$heightInches\" from '$valueStr'");
        } else {
          print("⚠️ Could not parse ft/in height from '$valueStr'");
        }
      }
      // Parse "5 ft 7 in" format (alternative)
      else if (valueStr.contains('ft') || valueStr.contains('in')) {
        final match = RegExp(r'(\d+)\s*ft\s*(\d+)\s*in').firstMatch(valueStr);
        if (match != null) {
          heightFeet = int.tryParse(match.group(1) ?? '') ?? 5;
          heightInches = int.tryParse(match.group(2) ?? '') ?? 7;
          heightUnit = 'ft/in';
          print(
              "✅ Restored height: $heightFeet ft $heightInches in from '$valueStr'");
        } else {
          print("⚠️ Could not parse ft in height from '$valueStr'");
        }
      } else {
        print("⚠️ Unknown height format: '$valueStr'");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localisation = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24.0),
      // height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ✅ Only render Back when allowed
                    if (widget.showBack)
                      InkWell(
                        onTap: widget.onBack,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Icon(
                            Icons.chevron_left,
                            size: 20,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      ),
                    if (widget.showSkipAll)
                      InkWell(
                        onTap: () async {
                          final shouldSkip = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text(localisation.confirmation),
                                content:
                                    Text(localisation.skipRemainingQuestions),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(false); // Yes
                                    },
                                    child: Text(localisation.no),
                                  ),
                                  TextButton(
                                    onPressed: widget.onSkipAll,
                                    child: Text(localisation.yes),
                                  ),
                                ],
                              );
                            },
                          );
                          if (shouldSkip == true) {
                            // show loader dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.5),
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(); // close loader
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  width:
                      MediaQuery.of(context).size.width - 48, // 80% of screen
                  child: DashedProgress(
                    totalDashes: widget.totalQuestions,
                    filledDashes: widget.currentQuestions,
                    filledColor: FlutterFlowTheme.of(context).primary,
                    unfilledColor: Colors.grey.shade300,
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 24),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (widget.description != '') ...[
                  const SizedBox(height: 16),
                  Text(
                    widget.description!,
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                if (widget.title.toLowerCase().contains('weigh'))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      custom_widgets.FFWheelPicker(
                        key: ValueKey('weight_picker_$weightUnit'),
                        width: 100,
                        height: 220.0,
                        min: (weightUnit == "kg") ? 20 : 44, // ~20kg in lbs
                        max: (weightUnit == "kg") ? 800 : 1760, // ~800kg in lbs
                        step: 1,
                        initialValue:
                            weightValue, // ✅ use stored value directly
                        itemExtent: 48.0,
                        selectedFontSize: 22.0,
                        unselectedFontSize: 18.0,
                        selectedChipRadius: 28.0,
                        chipHPadding: 16.0,
                        chipVPadding: 8.0,
                        diameterRatio: 2.0,
                        perspective: 0.003,
                        offAxisFraction: 0.0,
                        suffix: '',
                        loop: false,
                        haptics: true,
                        selectedTextColor: Colors.white,
                        unselectedTextColor: Color(0xFF9E9E9E),
                        selectedChipColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            weightValue =
                                value as int; // ✅ store in selected unit
                            print("Selected Weight: $weightValue $weightUnit");
                          });
                          updateWeight();
                          widget.onChanged(_currentValue);
                        },
                      ),
                      custom_widgets.FFWheelPicker(
                        key: const ValueKey('weight_unit_picker'),
                        items: const ["kg", "lbs"],
                        width: 100,
                        initialItem: weightUnit,
                        onChanged: (value) {
                          setState(() {
                            if (weightUnit != value) {
                              // ✅ Convert value properly when switching unit
                              if (value == "kg") {
                                weightValue =
                                    (weightValue / 2.20462).round(); // lbs → kg
                              } else {
                                weightValue =
                                    (weightValue * 2.20462).round(); // kg → lbs
                              }
                              weightUnit = value as String;
                              print("Weight Unit Changed: $weightUnit");
                              print("Current weight: $weightValue $weightUnit");
                            }
                          });
                          updateWeight();
                          widget.onChanged(_currentValue);
                        },
                      ),
                    ],
                  )
                else if (widget.title.toLowerCase().contains('height'))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (heightUnit == "cm")
                        custom_widgets.FFWheelPicker(
                          key: const ValueKey('height_picker_cm'),
                          width: 100,
                          height: 220.0,
                          min: 50,
                          max: 250,
                          step: 1,
                          initialValue: heightValue,
                          itemExtent: 48.0,
                          selectedFontSize: 22.0,
                          unselectedFontSize: 18.0,
                          selectedChipRadius: 28.0,
                          chipHPadding: 16.0,
                          chipVPadding: 8.0,
                          diameterRatio: 2.0,
                          perspective: 0.003,
                          offAxisFraction: 0.0,
                          suffix: '',
                          loop: false,
                          haptics: true,
                          selectedTextColor: Colors.white,
                          unselectedTextColor: Color(0xFF9E9E9E),
                          selectedChipColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              heightValue = value as int;
                              print("Selected Height: $heightValue cm");
                            });
                            updateHeight();
                            widget.onChanged(_currentValue);
                          },
                        )
                      else ...[
                        // Feet picker
                        custom_widgets.FFWheelPicker(
                          key: const ValueKey('height_picker_ft'),
                          width: 80,
                          height: 220.0,
                          min: 3,
                          max: 7,
                          step: 1,
                          initialValue: heightFeet,
                          itemExtent: 48.0,
                          selectedFontSize: 22.0,
                          unselectedFontSize: 18.0,
                          suffix: "'",
                          selectedChipRadius: 28.0,
                          chipHPadding: 16.0,
                          chipVPadding: 8.0,
                          diameterRatio: 2.0,
                          perspective: 0.003,
                          offAxisFraction: 0.0,
                          loop: false,
                          haptics: true,
                          selectedTextColor: Colors.white,
                          unselectedTextColor: Color(0xFF9E9E9E),
                          selectedChipColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              heightFeet = value as int;
                              print("Feet updated: $heightFeet");
                            });
                            updateHeight();
                            widget.onChanged(_currentValue);
                          },
                        ),

                        // Inches picker
                        custom_widgets.FFWheelPicker(
                          key: const ValueKey('height_picker_in'),
                          width: 80,
                          height: 220.0,
                          min: 0,
                          max: 11,
                          step: 1,
                          initialValue: heightInches,
                          itemExtent: 48.0,
                          selectedFontSize: 22.0,
                          unselectedFontSize: 18.0,
                          suffix: '"',
                          selectedChipRadius: 28.0,
                          chipHPadding: 16.0,
                          chipVPadding: 8.0,
                          diameterRatio: 2.0,
                          perspective: 0.003,
                          offAxisFraction: 0.0,
                          loop: false,
                          haptics: true,
                          selectedTextColor: Colors.white,
                          unselectedTextColor: Color(0xFF9E9E9E),
                          selectedChipColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              heightInches = value as int;
                              print("Inches updated: $heightInches");
                            });
                            updateHeight();
                            widget.onChanged(_currentValue);
                          },
                        ),
                      ],

                      // Unit selector
                      custom_widgets.FFWheelPicker(
                        key: const ValueKey('height_unit_picker'),
                        items: const ["cm", "ft/in"],
                        width: 100,
                        initialItem: heightUnit,
                        onChanged: (value) {
                          setState(() {
                            if (heightUnit != value) {
                              if (value == "cm") {
                                // convert ft+in → cm
                                final totalInches =
                                    (heightFeet * 12) + heightInches;
                                heightValue = (totalInches * 2.54).round();
                              } else {
                                // convert cm → ft+in
                                final totalInches =
                                    (heightValue / 2.54).round();
                                heightFeet = totalInches ~/ 12;
                                heightInches = totalInches % 12;
                              }
                              heightUnit = value as String;
                              print("Height Unit Changed: $heightUnit");
                            }
                          });
                          updateHeight();
                          widget.onChanged(_currentValue);
                        },
                      ),
                    ],
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildInputField(context),
                    ),
                  ),
                SizedBox(height: 140),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                FFButtonWidget(
                  onPressed: widget.onNext,
                  text:
                      widget.continueButtonText ?? localisation.continueButton,
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width - 60,
                    height: 50,
                    color: FlutterFlowTheme.of(context).primaryText,
                    textStyle: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                if (widget.isSkipVisible)
                  InkWell(
                    onTap: widget.inputType == 'medicalAppication'
                        ? () {
                            showMedicalConsentPopup(context, () async {
                              await widget.onNext
                                  ?.call(); // <-- Waits for all async work inside onNext
                              if (context.mounted) {
                                Navigator.pop(
                                    context); // <-- Closes popup only after onNext finishes
                              }
                            }, widget.onSkip);
                          }
                        : (widget.inputType == 'personliseExperience'
                            ? () {
                                showDefaultCriteriaPopup(
                                    context, widget.onNext, widget.onSkip);
                              }
                            : widget.onSkip),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.sizeOf(context).width - 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: widget.skipButtonBorder
                            ? Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText)
                            : null,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Text(
                        widget.skipText ?? localisation.skip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            color: FlutterFlowTheme.of(context).blackText,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    switch (widget.inputType) {
      case 'text':
        return _buildTextInput();
      case 'number':
        return _buildNumberInput();
      case 'single_choice':
        return _buildRadioButtonList();
      case 'boolean':
        return _buildRadioButtonList();
      case 'date':
        return _buildDateInput();
      case 'multi':
        return _buildMultiSelect();
      case 'location':
        return _buildLocationSelect();
      case 'dataOwnership':
        return _buildDataOwnership(context);
      case 'medicalAppication':
        return _buildMedicalApplication(context);
      case 'personliseExperience':
        return _buildPersonliseExperience(context);
      default:
        return _buildTextInput();
    }
  }

  Widget _buildTextInput() {
    final controller =
        TextEditingController(text: widget.initialValue?.toString() ?? '');
    return TextField(
      controller: controller,
      onChanged: (value) {
        _currentValue = value;
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Enter ${widget.title.toLowerCase()}',
        errorText: widget.errorText, // 👈 this shows inline error + red border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildNumberInput() {
    final controller =
        TextEditingController(text: widget.initialValue?.toString() ?? '');
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final numValue = int.tryParse(value);
        _currentValue = numValue;
        widget.onChanged(numValue);
      },
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Enter number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _currentValue,
          hint: Text(widget.placeholder ?? 'Select an option'),
          isExpanded: true,
          isDense: false,
          itemHeight: null,
          items: widget.options?.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _currentValue = newValue;
            });
            print('_currentVale= $_currentValue');
            widget.onChanged(newValue);
          },
        ),
      ),
    );
  }

  Widget _buildRadioButtonList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.options?.length ?? 0,
      itemBuilder: (context, index) {
        final value = widget.options![index];
        return RadioListTile<String>(
          title: Text(value),
          value: value,
          activeColor: FlutterFlowTheme.of(context).primaryText,
          groupValue: _currentValue,
          onChanged: (val) {
            setState(() => _currentValue = val);
            widget.onChanged(val);
          },
        );
      },
    );
  }

  Widget _buildDateInput() {
    // For the specific date of birth UI shown in the image
    if (widget.title.toLowerCase().contains('date of birth') ||
        widget.title.toLowerCase().contains('birth')) {
      return _buildDateOfBirthPicker();
    }

    // Regular date picker
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _currentValue ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _currentValue = picked;
          });
          widget.onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _currentValue != null
                  ? "${_currentValue.day}/${_currentValue.month}/${_currentValue.year}"
                  : widget.placeholder ?? 'Select date',
              style: TextStyle(
                color: _currentValue != null ? Colors.black : Colors.grey[600],
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDateOfBirthPicker() {
    DateTime selectedDate = _currentValue ?? DateTime.now();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildDateDropdown(
            value: selectedDate.day.toString().padLeft(2, '0'),
            items: List.generate(
                31, (index) => (index + 1).toString().padLeft(2, '0')),
            onChanged: (value) {
              if (value != null) {
                final newDate = DateTime(
                    selectedDate.year, selectedDate.month, int.parse(value));
                setState(() {
                  _currentValue = newDate;
                });
                widget.onChanged(newDate);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: _buildDateDropdown(
            value: _getMonthName(selectedDate.month),
            items: [
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December'
            ],
            onChanged: (value) {
              if (value != null) {
                final monthIndex = _getMonthIndex(value);
                final newDate =
                    DateTime(selectedDate.year, monthIndex, selectedDate.day);
                setState(() {
                  _currentValue = newDate;
                });
                widget.onChanged(newDate);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: _buildDateDropdown(
            value: selectedDate.year.toString(),
            items: List.generate(
                100, (index) => (DateTime.now().year - index).toString()),
            onChanged: (value) {
              if (value != null) {
                final newDate = DateTime(
                    int.parse(value), selectedDate.month, selectedDate.day);
                setState(() {
                  _currentValue = newDate;
                });
                widget.onChanged(newDate);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 14))),
            );
          }).toList(),
          onChanged: (val) {
            print('🌀 Date dropdown changed from "$value" → "$val"');
            onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildMultiSelect() {
    return Column(
      children: widget.options?.map((option) {
            final isSelected = _selectedMultiValues.contains(option);
            return CheckboxListTile(
              title: Text(option),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedMultiValues.add(option);
                  } else {
                    _selectedMultiValues.remove(option);
                  }
                });
                widget.onChanged(_selectedMultiValues);
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList() ??
          [],
    );
  }

  Widget _buildLocationSelect() {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            // 1. Load countries before opening dialog
            await fetchCodeLookupValues("countries_with_flag");

            // 2. Open dialog
            final selectedCountry = await showDialog<Map<String, String>>(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  alignment: AlignmentDirectional(0, 0)
                      .resolve(Directionality.of(context)),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(dialogContext).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: SelectCountryDialog(
                        countries: _countries
                            .map((row) => {
                                  "name": (row["key1"] ?? "").toString(),
                                  "flag": (row["key2"] ?? "").toString(),
                                  "keycode": row["keycode"].toString(),
                                })
                            .toList()
                            .cast<Map<String, String>>(),
                      ),
                    ),
                  ),
                );
              },
            );

            // 3. Update state with selected result
            if (selectedCountry != null) {
              final flag = selectedCountry["flag"] ?? "";
              final name = selectedCountry["name"] ?? "";
              setState(() {
                _currentValue = "$flag  $name";
              });
              final selectedKeyCode = selectedCountry["keycode"];
              widget.onChanged(selectedKeyCode);
              print("✅ User selected: $_currentValue");
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffededed),
              border: Border.all(
                color: hasError ? Colors.red : const Color(0xffdbdbdb),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentValue ??
                      AppLocalizations.of(context)!.question_country,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w500,
                    color:
                        _currentValue == null ? Colors.grey[600] : Colors.black,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 24),
              ],
            ),
          ),
        ),
        if (hasError) // 👈 Show error below
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDataOwnership(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        MessageBubble(
          normalText:
              'We do not use or share your data without consent. Please take the time to ',
          boldText: 'check the Data Transparency page in Settings.',
        ),
        MessageBubble(
          normalText:
              'For the app to function as intended, we need to track your consumption (which you input yourself) to provide you with; ',
          boldText:
              'your health score, sustainability score, fiber intake, protein intake, and micronutrient intake.',
        )
      ],
    );
  }

  Widget _buildPersonliseExperience(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        MessageBubble(
          normalText: '',
          boldText:
              'Your gender, activity level, weight, ethnicity, etc. can impact your dietary requirements. ',
          additionalText:
              'This means the app is tailored to your needs. Changes can be made to your profile and goals in Settings.',
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(19)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.personalized_experience3,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    height: 2,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("   - ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience4,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("   - ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience5,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("   - ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience6,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("   - ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience7,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("   - ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience8,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("   - ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience9,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("- ",
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(
                              size: 20))), // bullet
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: localization.personalized_experience10,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 2,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalApplication(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        MessageBubble(
          normalText:
              'This application is a tracking tool to help you reach your fiber, protein, micronutrient, and sustainability goals. We use publically available data from ',
          boldText: 'various scientific sources ',
          additionalText:
              'which are referenced throughout the application and our website.',
        ),
        MessageBubble(
          normalText: 'We are NOT a medical tool. Please ',
          boldText: 'consult relevant and qualified medical professional(s) ',
          additionalText: 'BEFORE making big lifestyle changes.',
        ),
        MessageBubble(
          normalText:
              'Please visit our terms and conditions and privacy policy for more information (you have already accepted them).  ',
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  int _getMonthIndex(String monthName) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months.indexOf(monthName) + 1;
  }
}

class DashedProgress extends StatelessWidget {
  final int totalDashes;
  final int filledDashes;
  final double dashHeight;
  final double dashSpacing;
  final Color filledColor;
  final Color unfilledColor;

  const DashedProgress({
    super.key,
    required this.totalDashes,
    required this.filledDashes,
    this.dashHeight = 6,
    this.dashSpacing = 6,
    this.filledColor = Colors.black,
    this.unfilledColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // total width available
        final totalWidth = constraints.maxWidth;

        // total spacing between dashes
        final totalSpacing = (totalDashes - 1) * dashSpacing;

        // width available for dashes
        final dashWidth = (totalWidth - totalSpacing) / totalDashes;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalDashes, (index) {
            final isFilled = index < filledDashes + 1;
            return Container(
              width: dashWidth,
              height: dashHeight,
              decoration: BoxDecoration(
                color: isFilled ? filledColor : unfilledColor,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String normalText;
  final String boldText;
  final String additionalText;
  final bool textCenter;
  const MessageBubble(
      {super.key,
      required this.normalText,
      this.boldText = '',
      this.additionalText = '',
      this.textCenter = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(19)),
      child: RichText(
        textAlign: textCenter ? TextAlign.center : TextAlign.left,
        text: TextSpan(
            text: normalText,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                height: 2,
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
            children: [
              TextSpan(
                  text: boldText,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(
                text: additionalText,
              ),
            ]),
      ),
    );
  }
}
