// Fixed FilterBottomSheetWidget - Complete Code
// Replace your entire FilterBottomSheetWidget class with this fixed version

import 'dart:ui';

import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
import 'package:the_lively_three/l10n/app_localizations.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/utils/create_community.dart';
import '/utils/filters_preferences_service.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  const FilterBottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  final createCommunity = CreateCommunityService();
  final filterPreferencesService = FilterPreferencesService();
  bool _isSwitched = false;

  // Dropdown data
  List<Map<String, dynamic>> _ageOptions = [];
  List<Map<String, dynamic>> _genderOptions = [];

  // Selected values
  int _selectedAgeCode = -999;
  int _selectedGenderCode = -999;

  bool _isLoading = true;
  bool _checkingSubscription = true;
  bool _hasValidSubscription = false;

  @override
  void initState() {
    super.initState();
    _initializeBottomSheet();
  }

  Future<void> _initializeBottomSheet() async {
    await _fetchDropdownData();
    await _loadSavedPreferences();
    await _checkUserSubscription();
  }

  Future<void> _loadSavedPreferences() async {
    try {
      final preferences =
          await filterPreferencesService.loadFilterPreferences(currentUserUid);

      if (preferences != null) {
        setState(() {
          _selectedAgeCode = preferences['age_code'] ?? -999;
          _selectedGenderCode = preferences['gender_code'] ?? -999;
          _isSwitched = preferences['apply_to_all_community'] ?? false;
        });

        debugPrint(
            '✅ Loaded filter preferences: Age=$_selectedAgeCode, Gender=$_selectedGenderCode, Toggle=$_isSwitched');
      } else {
        debugPrint('No saved preferences found, using defaults (-999)');
      }
    } catch (e) {
      debugPrint('❌ Error loading filter preferences: $e');
    }
  }

  Future<void> _saveFilterPreferences() async {
    try {
      final int ageToSave = _selectedAgeCode == -999 ? -1 : _selectedAgeCode;
      final int genderToSave = _selectedGenderCode == -999 ? -1 : _selectedGenderCode;

      await filterPreferencesService.saveFilterPreferences(
        userId: currentUserUid,
        ageCode: ageToSave,
        genderCode: genderToSave,
        locationCode: -1,
        ethnicityCode: -1,
        applyToAllCommunity: _isSwitched,
      );

      debugPrint('✅ Filter preferences saved: Age=$ageToSave, Gender=$genderToSave, Toggle=$_isSwitched');
    } catch (e) {
      debugPrint('❌ Error saving filter preferences: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save filter preferences'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _checkUserSubscription() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('has_subscription, subscription_expires_at')
          .eq('id', currentUserUid)
          .single();

      final bool hasSubscription = response['has_subscription'] ?? false;
      final String? expiresAtStr = response['subscription_expires_at'];

      bool isValid = false;
      if (hasSubscription && expiresAtStr != null) {
        final expiresAt = DateTime.parse(expiresAtStr);
        final now = DateTime.now();
        isValid = expiresAt.isAfter(now);
      }

      setState(() {
        _hasValidSubscription = isValid;
        _checkingSubscription = false;
      });

      if (!isValid && mounted) {
        await Future.delayed(const Duration(milliseconds: 200));

        await showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (context) => UpgradeSubscriptionPage(
            onSuccess: 'Home',
            onFailure: 'Home',
            popupTitle: AppLocalizations.of(context).popupTitleFilter,
            popupSubTitle: AppLocalizations.of(context).popupSubTitleFilter,
          ),
        );

        if (!_hasValidSubscription) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Error checking subscription: $e');
      setState(() {
        _checkingSubscription = false;
        _hasValidSubscription = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).communitySubscribeMsg),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _fetchDropdownData() async {
    try {
      final supabase = Supabase.instance.client;

      final ageResponse = await supabase
          .from('codelkup')
          .select('keycode, key1')
          .eq('lkcode', 'age_group')
          .order('keycode', ascending: true);

      final genderResponse = await supabase
          .from('codelkup')
          .select('keycode, key1')
          .eq('lkcode', 'Gender');

      final filteredAges =
          List<Map<String, dynamic>>.from(ageResponse).toList();
      final filteredGenders =
          List<Map<String, dynamic>>.from(genderResponse).toList();

      setState(() {
        _ageOptions = [
          {"keycode": -999, "key1": "Select Age"},
          ...filteredAges
        ];
        _genderOptions = [
          {"keycode": -999, "key1": "Select Gender"},
          ...filteredGenders
        ];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching codelkup data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ✅ FIXED: Updated _buildBottomSheetContent with proper SafeArea handling
// Fixed FilterBottomSheetWidget - Properly covers 50% of screen
// Replace the _buildBottomSheetContent method with this:

Widget _buildBottomSheetContent(BuildContext context) {
  var l10n = AppLocalizations.of(context)!;

  return Container(
    width: double.infinity,
    height: MediaQuery.sizeOf(context).height * 1.0,
    decoration: BoxDecoration(
      color: Color(0x37000000),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Header
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel,
                    color: FlutterFlowTheme.of(context).textGrey,
                    size: 24.0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
                    child: Text(
                      l10n.communityScoreFilter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).primaryText,
                        height: 1.2,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Divider
        Container(
          width: double.infinity,
          height: 0.5,
          decoration: BoxDecoration(
            color: Color(0xFF979797),
          ),
        ),
        // ✅ FIXED: Main content container that properly takes 50% height
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            minimum: EdgeInsets.zero, // Ensure no extra padding
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.50, // Exactly 50%
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Scrollable content area
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Column(
                            children: [
                              _buildDynamicDropdown(
                                label: l10n.ageLabel,
                                items: _ageOptions,
                                selectedCode: _selectedAgeCode,
                                onChanged: (int newCode) {
                                  setState(() => _selectedAgeCode = newCode);
                                },
                              ),
                              Container(
                                height: 1,
                                color: const Color.fromRGBO(151, 151, 151, 0.17),
                              ),
                              _buildDynamicDropdown(
                                label: l10n.genderLabel,
                                items: _genderOptions,
                                selectedCode: _selectedGenderCode,
                                onChanged: (int newCode) {
                                  setState(() => _selectedGenderCode = newCode);
                                },
                              ),
                              Container(
                                height: 1,
                                color: const Color.fromRGBO(151, 151, 151, 0.17),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Fixed buttons at bottom
                    Row(
                      children: [
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: l10n.cancel,
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              textStyle: TextStyle(
                                color:
                                    FlutterFlowTheme.of(context).primaryText,
                                fontSize: 12,
                              ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                color:
                                    FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: () async {
                              final bool ageNotSelected =
                                  _selectedAgeCode == -999;
                              final bool genderNotSelected =
                                  _selectedGenderCode == -999;

                              if (ageNotSelected && genderNotSelected) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(l10n.filterRequired),
                                      content: Text(l10n.selectFilterText),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              final int ageToSend =
                                  ageNotSelected ? -1 : _selectedAgeCode;
                              final int genderToSend =
                                  genderNotSelected ? -1 : _selectedGenderCode;

                              try {
                                await _saveFilterPreferences();

                                debugPrint(
                                    '✅ Filter preferences saved on Apply');

                                final Map<String, dynamic> communityValue =
                                    await createCommunity
                                        .createCommunityWithUsers(
                                  age: ageToSend,
                                  gender: genderToSend,
                                  location: -1,
                                  ethnicity: -1,
                                );

                                debugPrint(
                                    '✅ Community value fetched: $communityValue');

                                Navigator.pop(context, {
                                  'communityValue': communityValue['indicators'],
                                  'applyToAllCommunity': _isSwitched,
                                  'selectedFilters': {
                                    'age': ageToSend,
                                    'gender': genderToSend,
                                    'location': -1,
                                    'ethnicity': -1,
                                  }
                                });
                              } catch (e) {
                                debugPrint('❌ Error applying filters: $e');
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Error applying filters: $e'),
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            text: l10n.apply,
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                fontSize: 12,
                              ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    if (_checkingSubscription || _isLoading) {
      return Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasValidSubscription) {
      return Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AbsorbPointer(
              child: _buildBottomSheetContent(context),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 1.0,
            color: Colors.white.withOpacity(0.5),
          ),
        ],
      );
    }

    return _buildBottomSheetContent(context);
  }

  Widget _buildDynamicDropdown({
    required String label,
    required List<Map<String, dynamic>> items,
    required int selectedCode,
    required Function(int) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 140,
            height: 32,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(245, 245, 246, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedCode,
                isExpanded: true,
                alignment: Alignment.center,
                items: items
                    .map((item) => DropdownMenuItem<int>(
                          value: item['keycode'] as int,
                          alignment: Alignment.center,
                          child: Text(
                            item['key1'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(57, 60, 83, 1),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // ignore_for_file: prefer_const_constructors

// import 'dart:ui';

// import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
// import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
// import 'package:the_lively_three/l10n/app_localizations.dart';
// import 'package:the_lively_three/pages/subscription/subscription_widget.dart';

// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '/utils/create_community.dart';
// import '/utils/filters_preferences_service.dart';

// class FilterBottomSheetWidget extends StatefulWidget {
//   const FilterBottomSheetWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<FilterBottomSheetWidget> createState() =>
//       _FilterBottomSheetWidgetState();
// }

// class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
//   final createCommunity = CreateCommunityService();
//   final filterPreferencesService = FilterPreferencesService();
//   bool _isSwitched = false;

//   // Dropdown data
//   List<Map<String, dynamic>> _ageOptions = [];
//   List<Map<String, dynamic>> _genderOptions = [];

//   // Selected values
//   int _selectedAgeCode = -999; // Changed from -1 to -999 for consistency
//   int _selectedGenderCode = -999; // Changed from -1 to -999 for consistency

//   bool _isLoading = true;
//   bool _checkingSubscription = true;
//   bool _hasValidSubscription = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBottomSheet();
//   }

//   Future<void> _initializeBottomSheet() async {
//     // Fetch dropdown data first
//     await _fetchDropdownData();
    
//     // Load saved preferences to populate dropdowns
//     await _loadSavedPreferences();

//     // Then check subscription and show popup if needed
//     await _checkUserSubscription();
//   }

//   /// Load saved filter preferences for the user
//   Future<void> _loadSavedPreferences() async {
//     try {
//       final preferences =
//           await filterPreferencesService.loadFilterPreferences(currentUserUid);

//       if (preferences != null) {
//         setState(() {
//           // Use -999 as the default if no preference is saved
//           _selectedAgeCode = preferences['age_code'] ?? -999;
//           _selectedGenderCode = preferences['gender_code'] ?? -999;
//           _isSwitched = preferences['apply_to_all_community'] ?? false;
//         });

//         debugPrint(
//             '✅ Loaded filter preferences: Age=$_selectedAgeCode, Gender=$_selectedGenderCode, Toggle=$_isSwitched');
//       } else {
//         debugPrint('No saved preferences found, using defaults (-999)');
//       }
//     } catch (e) {
//       debugPrint('❌ Error loading filter preferences: $e');
//       // Continue with default values if loading fails
//     }
//   }

//   /// Save filter preferences
//   Future<void> _saveFilterPreferences() async {
//     try {
//       // Convert -999 (UI placeholder) to -1 (database value) for saving
//       final int ageToSave = _selectedAgeCode == -999 ? -1 : _selectedAgeCode;
//       final int genderToSave = _selectedGenderCode == -999 ? -1 : _selectedGenderCode;

//       await filterPreferencesService.saveFilterPreferences(
//         userId: currentUserUid,
//         ageCode: ageToSave,
//         genderCode: genderToSave,
//         locationCode: -1,
//         ethnicityCode: -1,
//         applyToAllCommunity: _isSwitched,
//       );

//       debugPrint('✅ Filter preferences saved: Age=$ageToSave, Gender=$genderToSave, Toggle=$_isSwitched');
//     } catch (e) {
//       debugPrint('❌ Error saving filter preferences: $e');

//       // Show error message to user
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to save filter preferences'),
//             duration: const Duration(seconds: 2),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _checkUserSubscription() async {
//     try {
//       final response = await Supabase.instance.client
//           .from('users')
//           .select('has_subscription, subscription_expires_at')
//           .eq('id', currentUserUid)
//           .single();

//       final bool hasSubscription = response['has_subscription'] ?? false;
//       final String? expiresAtStr = response['subscription_expires_at'];

//       bool isValid = false;
//       if (hasSubscription && expiresAtStr != null) {
//         final expiresAt = DateTime.parse(expiresAtStr);
//         final now = DateTime.now();
//         isValid = expiresAt.isAfter(now);
//       }

//       setState(() {
//         _hasValidSubscription = isValid;
//         _checkingSubscription = false;
//       });

//       if (!isValid && mounted) {
//         // Add a short delay to let the UI render the blurred background
//         await Future.delayed(const Duration(milliseconds: 200));

//         await showDialog(
//           context: context,
//           barrierDismissible: false,
//           barrierColor: Colors.transparent,
//           builder: (context) => UpgradeSubscriptionPage(
//             onSuccess: 'Home',
//             onFailure: 'Home',
//             popupTitle: AppLocalizations.of(context).popupTitleFilter,
//             popupSubTitle: AppLocalizations.of(context).popupSubTitleFilter,
//           ),
//         );

//         // After dialog closes, check if still mounted and close bottom sheet
//         if (!_hasValidSubscription) {
//           Navigator.pop(context);
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       debugPrint('Error checking subscription: $e');
//       setState(() {
//         _checkingSubscription = false;
//         _hasValidSubscription = false;
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(AppLocalizations.of(context).communitySubscribeMsg),
//             duration: const Duration(seconds: 3),
//             backgroundColor: Colors.orange,
//           ),
//         );

//         // Close bottom sheet after error
//         await Future.delayed(const Duration(milliseconds: 500));
//         if (mounted) {
//           Navigator.pop(context);
//         }
//       }
//     }
//   }

//   Future<void> _fetchDropdownData() async {
//     try {
//       final supabase = Supabase.instance.client;

//       // Fetch age group options
//       final ageResponse = await supabase
//           .from('codelkup')
//           .select('keycode, key1')
//           .eq('lkcode', 'age_group')
//           .order('keycode', ascending: true);

//       // Fetch gender options
//       final genderResponse = await supabase
//           .from('codelkup')
//           .select('keycode, key1')
//           .eq('lkcode', 'Gender');

//       final filteredAges =
//           List<Map<String, dynamic>>.from(ageResponse).toList();
//       final filteredGenders =
//           List<Map<String, dynamic>>.from(genderResponse).toList();

//       setState(() {
//         _ageOptions = [
//           {"keycode": -999, "key1": "Select Age"},
//           ...filteredAges
//         ];
//         _genderOptions = [
//           {"keycode": -999, "key1": "Select Gender"},
//           ...filteredGenders
//         ];
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('Error fetching codelkup data: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Widget _buildBottomSheetContent(BuildContext context) {
//     var l10n = AppLocalizations.of(context)!;

//     return Container(
//       width: double.infinity,
//       height: MediaQuery.sizeOf(context).height * 1.0,
//       decoration: BoxDecoration(
//         color: Color(0x37000000),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     splashColor: Colors.transparent,
//                     focusColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     onTap: () async {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.cancel,
//                       color: FlutterFlowTheme.of(context).textGrey,
//                       size: 24.0,
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding:
//                           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
//                       child: Text(
//                         l10n.communityScoreFilter,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: FlutterFlowTheme.of(context).primaryText,
//                           height: 1.2,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 0.5,
//             decoration: BoxDecoration(
//               color: Color(0xFF979797),
//             ),
//           ),
//           Container(
//             height: MediaQuery.sizeOf(context).height * 0.48,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   child: Column(
//                     children: [
//                       _buildDynamicDropdown(
//                         label: l10n.ageLabel,
//                         items: _ageOptions,
//                         selectedCode: _selectedAgeCode,
//                         onChanged: (int newCode) {
//                           setState(() => _selectedAgeCode = newCode);
//                         },
//                       ),
//                       Container(
//                         height: 1,
//                         color: const Color.fromRGBO(151, 151, 151, 0.17),
//                       ),
//                       _buildDynamicDropdown(
//                         label: l10n.genderLabel,
//                         items: _genderOptions,
//                         selectedCode: _selectedGenderCode,
//                         onChanged: (int newCode) {
//                           setState(() => _selectedGenderCode = newCode);
//                         },
//                       ),
//                       Container(
//                         height: 1,
//                         color: const Color.fromRGBO(151, 151, 151, 0.17),
//                       ),
//                       const SizedBox(height: 8),
//                       // Wrap(
//                       //   crossAxisAlignment: WrapCrossAlignment.center,
//                       //   alignment: WrapAlignment.center,
//                       //   runAlignment: WrapAlignment.center,
//                       //   spacing: 8,
//                       //   runSpacing: 4,
//                       //   children: [
//                       //     Text(
//                       //       l10n.applyAllCommunity,
//                       //       textAlign: TextAlign.center,
//                       //       style: TextStyle(
//                       //         fontSize: 12,
//                       //         color: FlutterFlowTheme.of(context).textGrey,
//                       //         height: 1.67,
//                       //       ),
//                       //     ),
//                       //     SwitchButton(
//                       //       value: _isSwitched,
//                       //       onChanged: (value) async {
//                       //         setState(() {
//                       //           _isSwitched = value;
//                       //         });

//                       //         debugPrint('🔄 Toggle changed to: $value');

//                       //         // Save the toggle state immediately
//                       //         await _saveFilterPreferences();

//                       //         if (value) {
//                       //           // Toggle ON
//                       //           if (_selectedAgeCode != -999 ||
//                       //               _selectedGenderCode != -999) {
//                       //             if (mounted) {
//                       //               ScaffoldMessenger.of(context).showSnackBar(
//                       //                 SnackBar(
//                       //                   content: Text(
//                       //                       'Filters will apply to all communities'),
//                       //                   duration: const Duration(seconds: 2),
//                       //                   backgroundColor: Colors.green,
//                       //                 ),
//                       //               );
//                       //             }
//                       //           } else {
//                       //             if (mounted) {
//                       //               ScaffoldMessenger.of(context).showSnackBar(
//                       //                 SnackBar(
//                       //                   content: Text(
//                       //                       'Select filters and click Apply to save'),
//                       //                   duration: const Duration(seconds: 2),
//                       //                   backgroundColor: Colors.orange,
//                       //                 ),
//                       //               );
//                       //             }
//                       //           }
//                       //         } else {
//                       //           // Toggle OFF
//                       //           if (mounted) {
//                       //             ScaffoldMessenger.of(context).showSnackBar(
//                       //               SnackBar(
//                       //                 content: Text(
//                       //                     'Filters will not apply to all communities'),
//                       //                 duration: const Duration(seconds: 2),
//                       //                 backgroundColor: Colors.blue,
//                       //               ),
//                       //             );
//                       //           }
//                       //         }
//                       //       },
//                       //       height: 26,
//                       //       showFilterIcon: true,
//                       //     ),
//                       //   ],
//                       // ),
                      
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: FFButtonWidget(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         text: l10n.cancel,
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 50,
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           textStyle: TextStyle(
//                             color: FlutterFlowTheme.of(context).primaryText,
//                             fontSize: 12,
//                           ),
//                           elevation: 2.0,
//                           borderRadius: BorderRadius.circular(24.0),
//                           borderSide: BorderSide(
//                             color: FlutterFlowTheme.of(context).primaryText,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: FFButtonWidget(
//                         onPressed: () async {
//                           final bool ageNotSelected = _selectedAgeCode == -999;
//                           final bool genderNotSelected =
//                               _selectedGenderCode == -999;

//                           // Check if at least one filter is selected
//                           if (ageNotSelected && genderNotSelected) {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text(l10n.filterRequired),
//                                   content: Text(l10n.selectFilterText),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: Text('OK'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                             return;
//                           }

//                           final int ageToSend =
//                               ageNotSelected ? -1 : _selectedAgeCode;
//                           final int genderToSend =
//                               genderNotSelected ? -1 : _selectedGenderCode;

//                           try {
//                             // ✅ ALWAYS save filter preferences on Apply click
//                             await _saveFilterPreferences();
                            
//                             debugPrint('✅ Filter preferences saved on Apply');

//                             // Fetch community data with selected filters
//                             final Map<int, double> communityValue =
//                                 await createCommunity.createCommunityWithUsers(
//                               age: ageToSend,
//                               gender: genderToSend,
//                               location: -1,
//                               ethnicity: -1,
//                             );

//                             debugPrint(
//                                 '✅ Community value fetched: $communityValue');

//                             // Return the community values to the calling screen
//                             Navigator.pop(context, {
//                               'communityValue': communityValue,
//                               'applyToAllCommunity': _isSwitched,
//                               'selectedFilters': {
//                                 'age': ageToSend,
//                                 'gender': genderToSend,
//                                 'location': -1,
//                                 'ethnicity': -1,
//                               }
//                             });
//                           } catch (e) {
//                             debugPrint('❌ Error applying filters: $e');
//                             if (mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Error applying filters: $e'),
//                                   duration: const Duration(seconds: 3),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                         text: l10n.apply,
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 50,
//                           color: FlutterFlowTheme.of(context).primaryText,
//                           textStyle: TextStyle(
//                             color:
//                                 FlutterFlowTheme.of(context).primaryBackground,
//                             fontSize: 12,
//                           ),
//                           elevation: 2.0,
//                           borderRadius: BorderRadius.circular(24.0),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show loading indicator while checking subscription or fetching data
//     if (_checkingSubscription || _isLoading) {
//       return Container(
//         width: double.infinity,
//         height: MediaQuery.sizeOf(context).height * 0.5,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12),
//             topRight: Radius.circular(12),
//           ),
//         ),
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     // Show blurred content if subscription is invalid
//     if (!_hasValidSubscription) {
//       return Stack(
//         children: [
//           ImageFiltered(
//             imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//             child: AbsorbPointer(
//               child: _buildBottomSheetContent(context),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: MediaQuery.sizeOf(context).height * 1.0,
//             color: Colors.white.withOpacity(0.5),
//           ),
//         ],
//       );
//     }

//     // Show normal content if subscription is valid
//     return _buildBottomSheetContent(context);
//   }

//   Widget _buildDynamicDropdown({
//     required String label,
//     required List<Map<String, dynamic>> items,
//     required int selectedCode,
//     required Function(int) onChanged,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Container(
//             width: 140,
//             height: 32,
//             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//             decoration: BoxDecoration(
//               color: const Color.fromRGBO(245, 245, 246, 1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<int>(
//                 value: selectedCode,
//                 isExpanded: true,
//                 alignment: Alignment.center,
//                 items: items
//                     .map((item) => DropdownMenuItem<int>(
//                           value: item['keycode'] as int,
//                           alignment: Alignment.center,
//                           child: Text(
//                             item['key1'] as String,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: (val) {
//                   if (val != null) onChanged(val);
//                 },
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   size: 20,
//                   color: FlutterFlowTheme.of(context).primaryText,
//                 ),
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromRGBO(57, 60, 83, 1),
//                 ),
//                 dropdownColor: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
