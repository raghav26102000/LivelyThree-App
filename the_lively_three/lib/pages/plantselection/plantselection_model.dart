import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/choice_chips_plants/choice_chips_plants_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/plant_selection.dart';
import 'dart:ui';
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'plantselection_widget.dart' show PlantselectionWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlantselectionModel extends FlutterFlowModel<PlantselectionWidget> {
  ///  Local state fields for this page.

  bool isShowingSearchBar = false;

  bool isVegsAdded = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

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

  bool isMonday = false;

  bool isTuesday = false;

  bool isWednesday = false;

  bool isThursday = false;

  bool isFriday = false;

  bool isSaturday = false;

  bool isSunday = false;

  int queriedMaxWeekNumber = 0;

  String? plantname;

  String? color;

  int? locPlantId;

  double? fiberLower;

  double? fiberActual;

  double? fiberUpper;

  double? proteinLower;

  double? proteinActual;

  double? proteinUpper;

  double? fatLower;

  double? fatActual;

  double? fatUpper;

  double? carbsLower;

  double? carbsActual;

  double? carbsUpper;

  String? fiberUpperPlant;

  String? fiberLowerPlant;

  String? proteinUpperPlant;

  String? proteinLowerPlant;

  String? fatUpperPlant;

  String? fatLowerPlant;

  String? carbsUpperPlant;

  String? carbsLowerPlant;

  int? fiberRating;

  int? proteinRating;

  bool isSortedAlphabetically = false;

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? plantSelectionController;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels1;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels2;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels3;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels4;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels5;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels6;
  // Models for choiceChipsPlants dynamic component.
  late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
      choiceChipsPlantsModels7;

  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM - EEE');
    return formatter.format(now);
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}

// class PlantselectionModel extends FlutterFlowModel<PlantselectionWidget> {
//   ///  Local state fields for this page.

//   List<String> ccSelectedLabelListRed = [];
//   void addToCcSelectedLabelListRed(String item) =>
//       ccSelectedLabelListRed.add(item);
//   void removeFromCcSelectedLabelListRed(String item) =>
//       ccSelectedLabelListRed.remove(item);
//   void removeAtIndexFromCcSelectedLabelListRed(int index) =>
//       ccSelectedLabelListRed.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListRed(int index, String item) =>
//       ccSelectedLabelListRed.insert(index, item);
//   void updateCcSelectedLabelListRedAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListRed[index] = updateFn(ccSelectedLabelListRed[index]);

//   List<String> ccSelectedLabelListOrange = [];
//   void addToCcSelectedLabelListOrange(String item) =>
//       ccSelectedLabelListOrange.add(item);
//   void removeFromCcSelectedLabelListOrange(String item) =>
//       ccSelectedLabelListOrange.remove(item);
//   void removeAtIndexFromCcSelectedLabelListOrange(int index) =>
//       ccSelectedLabelListOrange.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListOrange(int index, String item) =>
//       ccSelectedLabelListOrange.insert(index, item);
//   void updateCcSelectedLabelListOrangeAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListOrange[index] =
//           updateFn(ccSelectedLabelListOrange[index]);

//   List<String> ccSelectedLabelListYellow = [];
//   void addToCcSelectedLabelListYellow(String item) =>
//       ccSelectedLabelListYellow.add(item);
//   void removeFromCcSelectedLabelListYellow(String item) =>
//       ccSelectedLabelListYellow.remove(item);
//   void removeAtIndexFromCcSelectedLabelListYellow(int index) =>
//       ccSelectedLabelListYellow.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListYellow(int index, String item) =>
//       ccSelectedLabelListYellow.insert(index, item);
//   void updateCcSelectedLabelListYellowAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListYellow[index] =
//           updateFn(ccSelectedLabelListYellow[index]);

//   List<String> ccSelectedLabelListGreen = [];
//   void addToCcSelectedLabelListGreen(String item) =>
//       ccSelectedLabelListGreen.add(item);
//   void removeFromCcSelectedLabelListGreen(String item) =>
//       ccSelectedLabelListGreen.remove(item);
//   void removeAtIndexFromCcSelectedLabelListGreen(int index) =>
//       ccSelectedLabelListGreen.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListGreen(int index, String item) =>
//       ccSelectedLabelListGreen.insert(index, item);
//   void updateCcSelectedLabelListGreenAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListGreen[index] =
//           updateFn(ccSelectedLabelListGreen[index]);

//   List<String> ccSelectedLabelListPurple = [];
//   void addToCcSelectedLabelListPurple(String item) =>
//       ccSelectedLabelListPurple.add(item);
//   void removeFromCcSelectedLabelListPurple(String item) =>
//       ccSelectedLabelListPurple.remove(item);
//   void removeAtIndexFromCcSelectedLabelListPurple(int index) =>
//       ccSelectedLabelListPurple.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListPurple(int index, String item) =>
//       ccSelectedLabelListPurple.insert(index, item);
//   void updateCcSelectedLabelListPurpleAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListPurple[index] =
//           updateFn(ccSelectedLabelListPurple[index]);

//   List<String> ccSelectedLabelListBrown = [];
//   void addToCcSelectedLabelListBrown(String item) =>
//       ccSelectedLabelListBrown.add(item);
//   void removeFromCcSelectedLabelListBrown(String item) =>
//       ccSelectedLabelListBrown.remove(item);
//   void removeAtIndexFromCcSelectedLabelListBrown(int index) =>
//       ccSelectedLabelListBrown.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListBrown(int index, String item) =>
//       ccSelectedLabelListBrown.insert(index, item);
//   void updateCcSelectedLabelListBrownAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListBrown[index] =
//           updateFn(ccSelectedLabelListBrown[index]);

//   List<String> ccSelectedLabelListWhite = [];
//   void addToCcSelectedLabelListWhite(String item) =>
//       ccSelectedLabelListWhite.add(item);
//   void removeFromCcSelectedLabelListWhite(String item) =>
//       ccSelectedLabelListWhite.remove(item);
//   void removeAtIndexFromCcSelectedLabelListWhite(int index) =>
//       ccSelectedLabelListWhite.removeAt(index);
//   void insertAtIndexInCcSelectedLabelListWhite(int index, String item) =>
//       ccSelectedLabelListWhite.insert(index, item);
//   void updateCcSelectedLabelListWhiteAtIndex(
//           int index, Function(String) updateFn) =>
//       ccSelectedLabelListWhite[index] =
//           updateFn(ccSelectedLabelListWhite[index]);

//   bool isMonday = false;

//   bool isTuesday = false;

//   bool isWednesday = false;

//   bool isThursday = false;

//   bool isFriday = false;

//   bool isSaturday = false;

//   bool isSunday = false;

//   int queriedMaxWeekNumber = 0;

//   String? plantname;

//   String? color;

//   int? locPlantId;

//   double? fiberLower;

//   double? fiberActual;

//   double? fiberUpper;

//   double? proteinLower;

//   double? proteinActual;

//   double? proteinUpper;

//   double? fatLower;

//   double? fatActual;

//   double? fatUpper;

//   double? carbsLower;

//   double? carbsActual;

//   double? carbsUpper;

//   String? fiberUpperPlant;

//   String? fiberLowerPlant;

//   String? proteinUpperPlant;

//   String? proteinLowerPlant;

//   String? fatUpperPlant;

//   String? fatLowerPlant;

//   String? carbsUpperPlant;

//   String? carbsLowerPlant;

//   int? fiberRating;

//   int? proteinRating;

//   ///  State fields for stateful widgets in this page.

//   TutorialCoachMark? plantSelectionController;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels1;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels2;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels3;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels4;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels5;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels6;
//   // Models for choiceChipsPlants dynamic component.
//   late FlutterFlowDynamicModels<ChoiceChipsPlantsModel>
//       choiceChipsPlantsModels7;

//   @override
//   void initState(BuildContext context) {
//     choiceChipsPlantsModels1 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//     choiceChipsPlantsModels2 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//     choiceChipsPlantsModels3 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//     choiceChipsPlantsModels4 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//     choiceChipsPlantsModels5 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//     choiceChipsPlantsModels6 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//     choiceChipsPlantsModels7 =
//         FlutterFlowDynamicModels(() => ChoiceChipsPlantsModel());
//   }

//   @override
//   void dispose() {
//     plantSelectionController?.finish();
//     choiceChipsPlantsModels1.dispose();
//     choiceChipsPlantsModels2.dispose();
//     choiceChipsPlantsModels3.dispose();
//     choiceChipsPlantsModels4.dispose();
//     choiceChipsPlantsModels5.dispose();
//     choiceChipsPlantsModels6.dispose();
//     choiceChipsPlantsModels7.dispose();
//   }
// }
