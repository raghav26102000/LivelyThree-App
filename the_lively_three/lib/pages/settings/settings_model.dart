import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/bottom_sheet_email_change/bottom_sheet_email_change_widget.dart';
import '/components/data_contract_entry/data_contract_entry_widget.dart';
import '/components/infobox_generaloptin/infobox_generaloptin_widget.dart';
import '/components/settings_choice_chip/settings_choice_chip_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/walkthroughs/settings_plants.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'settings_widget.dart' show SettingsWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsModel extends FlutterFlowModel<SettingsWidget> {
  ///  Local state fields for this page.

  List<String> ccSelectedLabelListRed = [];
  void addToCcSelectedLabelListRed(String item) =>
      ccSelectedLabelListRed.add(item);
  void removeFromCcSelectedLabelListRed(String item) =>
      ccSelectedLabelListRed.remove(item);
  void removeAtIndexFromCcSelectedLabelListRed(int index) =>
      ccSelectedLabelListRed.removeAt(index);
  void insertAtIndexInCcSelectedLabelListRed(int index, String item) =>
      ccSelectedLabelListRed.insert(index, item);
  void updateCcSelectedLabelListRedAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListRed[index] = updateFn(ccSelectedLabelListRed[index]);

  List<String> ccSelectedLabelListYellow = [];
  void addToCcSelectedLabelListYellow(String item) =>
      ccSelectedLabelListYellow.add(item);
  void removeFromCcSelectedLabelListYellow(String item) =>
      ccSelectedLabelListYellow.remove(item);
  void removeAtIndexFromCcSelectedLabelListYellow(int index) =>
      ccSelectedLabelListYellow.removeAt(index);
  void insertAtIndexInCcSelectedLabelListYellow(int index, String item) =>
      ccSelectedLabelListYellow.insert(index, item);
  void updateCcSelectedLabelListYellowAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListYellow[index] =
          updateFn(ccSelectedLabelListYellow[index]);

  List<String> ccSelectedLabelListOrange = [];
  void addToCcSelectedLabelListOrange(String item) =>
      ccSelectedLabelListOrange.add(item);
  void removeFromCcSelectedLabelListOrange(String item) =>
      ccSelectedLabelListOrange.remove(item);
  void removeAtIndexFromCcSelectedLabelListOrange(int index) =>
      ccSelectedLabelListOrange.removeAt(index);
  void insertAtIndexInCcSelectedLabelListOrange(int index, String item) =>
      ccSelectedLabelListOrange.insert(index, item);
  void updateCcSelectedLabelListOrangeAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListOrange[index] =
          updateFn(ccSelectedLabelListOrange[index]);

  List<String> ccSelectedLabelListGreen = [];
  void addToCcSelectedLabelListGreen(String item) =>
      ccSelectedLabelListGreen.add(item);
  void removeFromCcSelectedLabelListGreen(String item) =>
      ccSelectedLabelListGreen.remove(item);
  void removeAtIndexFromCcSelectedLabelListGreen(int index) =>
      ccSelectedLabelListGreen.removeAt(index);
  void insertAtIndexInCcSelectedLabelListGreen(int index, String item) =>
      ccSelectedLabelListGreen.insert(index, item);
  void updateCcSelectedLabelListGreenAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListGreen[index] =
          updateFn(ccSelectedLabelListGreen[index]);

  List<String> ccSelectedLabelListPurple = [];
  void addToCcSelectedLabelListPurple(String item) =>
      ccSelectedLabelListPurple.add(item);
  void removeFromCcSelectedLabelListPurple(String item) =>
      ccSelectedLabelListPurple.remove(item);
  void removeAtIndexFromCcSelectedLabelListPurple(int index) =>
      ccSelectedLabelListPurple.removeAt(index);
  void insertAtIndexInCcSelectedLabelListPurple(int index, String item) =>
      ccSelectedLabelListPurple.insert(index, item);
  void updateCcSelectedLabelListPurpleAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListPurple[index] =
          updateFn(ccSelectedLabelListPurple[index]);

  List<String> ccSelectedLabelListBrown = [];
  void addToCcSelectedLabelListBrown(String item) =>
      ccSelectedLabelListBrown.add(item);
  void removeFromCcSelectedLabelListBrown(String item) =>
      ccSelectedLabelListBrown.remove(item);
  void removeAtIndexFromCcSelectedLabelListBrown(int index) =>
      ccSelectedLabelListBrown.removeAt(index);
  void insertAtIndexInCcSelectedLabelListBrown(int index, String item) =>
      ccSelectedLabelListBrown.insert(index, item);
  void updateCcSelectedLabelListBrownAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListBrown[index] =
          updateFn(ccSelectedLabelListBrown[index]);

  List<String> ccSelectedLabelListWhite = [];
  void addToCcSelectedLabelListWhite(String item) =>
      ccSelectedLabelListWhite.add(item);
  void removeFromCcSelectedLabelListWhite(String item) =>
      ccSelectedLabelListWhite.remove(item);
  void removeAtIndexFromCcSelectedLabelListWhite(int index) =>
      ccSelectedLabelListWhite.removeAt(index);
  void insertAtIndexInCcSelectedLabelListWhite(int index, String item) =>
      ccSelectedLabelListWhite.insert(index, item);
  void updateCcSelectedLabelListWhiteAtIndex(
          int index, Function(String) updateFn) =>
      ccSelectedLabelListWhite[index] =
          updateFn(ccSelectedLabelListWhite[index]);

  int? countryMax;

  bool hasSuccess = false;

  String? errorMessage;

  String? verificationStatus;

  String? oldEmail;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? settingsPlantsController;
  // Stores action output result for [Backend Call - Query Rows] action in Settings widget.
  List<UserregionRow>? actionoutputCountrylist;
  // Stores action output result for [Backend Call - Query Rows] action in Settings widget.
  List<WeeklyselectedplantRow>? weeklySelectedPlantsOutput;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // Stores action output result for [Custom Action - requestEmailChange] action in Button widget.
  dynamic? requestEmailChangeOutput;
  // Stores action output result for [Bottom Sheet - bottomSheetEmailChange] action in Button widget.
  String? newEmailFromBottomSheet;
  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;
  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;
  // State field(s) for fiberdropdown widget.
  double? fiberdropdownValue;
  FormFieldController<double>? fiberdropdownValueController;
  // State field(s) for proteindropdown widget.
  double? proteindropdownValue;
  FormFieldController<double>? proteindropdownValueController;
  DateTime? datePicked;
  // State field(s) for height widget.
  FocusNode? heightFocusNode;
  TextEditingController? heightTextController;
  String? Function(BuildContext, String?)? heightTextControllerValidator;
  // State field(s) for gender widget.
  String? genderValue;
  FormFieldController<String>? genderValueController;
  // State field(s) for region widget.
  FocusNode? regionFocusNode;
  TextEditingController? regionTextController;
  String? Function(BuildContext, String?)? regionTextControllerValidator;
  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;
  String? Function(BuildContext, String?)? phoneTextControllerValidator;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels1;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels2;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels3;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels4;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels5;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels6;
  // Models for settingsChoiceChip dynamic component.
  late FlutterFlowDynamicModels<SettingsChoiceChipModel>
      settingsChoiceChipModels7;
  // Stores action output result for [Backend Call - Query Rows] action in Tab widget.
  List<UsersRow>? outputUser;
  // Models for dataContractEntry dynamic component.
  late FlutterFlowDynamicModels<DataContractEntryModel> dataContractEntryModels;
  // State field(s) for sub_dropdown widget.
  bool? subDropdownValue;
  FormFieldController<bool>? subDropdownValueController;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<UsersRow>? updateHasSuccessOutput;

  FormFieldController<String>? languageDropdownController;

  // Current dropdown value
  String? languageDropdownValue;

  @override
  void initState(BuildContext context) {
    settingsChoiceChipModels1 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    settingsChoiceChipModels2 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    settingsChoiceChipModels3 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    settingsChoiceChipModels4 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    settingsChoiceChipModels5 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    settingsChoiceChipModels6 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    settingsChoiceChipModels7 =
        FlutterFlowDynamicModels(() => SettingsChoiceChipModel());
    dataContractEntryModels =
        FlutterFlowDynamicModels(() => DataContractEntryModel());
  }

  @override
  void dispose() {
    settingsPlantsController?.finish();
    tabBarController?.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();

    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();

    regionFocusNode?.dispose();
    regionTextController?.dispose();

    phoneFocusNode?.dispose();
    phoneTextController?.dispose();

    settingsChoiceChipModels1.dispose();
    settingsChoiceChipModels2.dispose();
    settingsChoiceChipModels3.dispose();
    settingsChoiceChipModels4.dispose();
    settingsChoiceChipModels5.dispose();
    settingsChoiceChipModels6.dispose();
    settingsChoiceChipModels7.dispose();
    dataContractEntryModels.dispose();
  }
}
