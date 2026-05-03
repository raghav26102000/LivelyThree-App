import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/nutrient_value/nutrient_value_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'nutrientdetails_widget.dart' show NutrientdetailsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NutrientdetailsModel extends FlutterFlowModel<NutrientdetailsWidget> {
  ///  Local state fields for this page.

  int counter = 0;

  int nutrientmax = 0;

  int? relmax;

  int? deltaIdmax;

  List<DeltaIdDataTypeStruct> deltaIndexList = [];
  void addToDeltaIndexList(DeltaIdDataTypeStruct item) =>
      deltaIndexList.add(item);
  void removeFromDeltaIndexList(DeltaIdDataTypeStruct item) =>
      deltaIndexList.remove(item);
  void removeAtIndexFromDeltaIndexList(int index) =>
      deltaIndexList.removeAt(index);
  void insertAtIndexInDeltaIndexList(int index, DeltaIdDataTypeStruct item) =>
      deltaIndexList.insert(index, item);
  void updateDeltaIndexListAtIndex(
          int index, Function(DeltaIdDataTypeStruct) updateFn) =>
      deltaIndexList[index] = updateFn(deltaIndexList[index]);

  int? relbluenutrientIdx;

  double? nutrientValue;

  String? nutrientReference;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Nutrientdetails widget.
  List<NutrientRow>? nutrientOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Nutrientdetails widget.
  List<ViewNutrientperplantRow>? relBlueNutrientOutput;
  // Stores action output result for [Backend Call - Query Rows] action in Nutrientdetails widget.
  List<ViewNutrientperplantRow>? viewBlueNutrientOutput;
  // Stores action output result for [Backend Call - Insert Row] action in Nutrientdetails widget.
  NutrientperplantRow? insertOutput;
  // Stores action output result for [Custom Action - deltaids] action in Nutrientdetails widget.
  List<int>? deltaIdList;
  // Models for nutrientValue dynamic component.
  late FlutterFlowDynamicModels<NutrientValueModel> nutrientValueModels;
  // Stores action output result for [Backend Call - Update Row(s)] action in nutrientValue widget.
  List<NutrientperplantRow>? referenceoutput;

  @override
  void initState(BuildContext context) {
    nutrientValueModels = FlutterFlowDynamicModels(() => NutrientValueModel());
  }

  @override
  void dispose() {
    nutrientValueModels.dispose();
  }
}
