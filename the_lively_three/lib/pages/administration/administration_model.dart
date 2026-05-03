import '/backend/supabase/supabase.dart';
import '/components/agrimethod_data_entry/agrimethod_data_entry_widget.dart';
import '/components/blueprint_data_entry/blueprint_data_entry_widget.dart';
import '/components/climate_condition_data_entry/climate_condition_data_entry_widget.dart';
import '/components/create_data_list_item/create_data_list_item_widget.dart';
import '/components/localize_data_entry/localize_data_entry_widget.dart';
import '/components/nutrient_data_entry/nutrient_data_entry_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'administration_widget.dart' show AdministrationWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdministrationModel extends FlutterFlowModel<AdministrationWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for blueprintDataEntry component.
  late BlueprintDataEntryModel blueprintDataEntryModel;
  // Model for nutrientDataEntry component.
  late NutrientDataEntryModel nutrientDataEntryModel;
  // Model for climateConditionDataEntry component.
  late ClimateConditionDataEntryModel climateConditionDataEntryModel;
  // Model for agrimethodDataEntry component.
  late AgrimethodDataEntryModel agrimethodDataEntryModel;
  // Model for localizeDataEntry component.
  late LocalizeDataEntryModel localizeDataEntryModel;
  // Model for createDataListItem component.
  late CreateDataListItemModel createDataListItemModel;

  @override
  void initState(BuildContext context) {
    blueprintDataEntryModel =
        createModel(context, () => BlueprintDataEntryModel());
    nutrientDataEntryModel =
        createModel(context, () => NutrientDataEntryModel());
    climateConditionDataEntryModel =
        createModel(context, () => ClimateConditionDataEntryModel());
    agrimethodDataEntryModel =
        createModel(context, () => AgrimethodDataEntryModel());
    localizeDataEntryModel =
        createModel(context, () => LocalizeDataEntryModel());
    createDataListItemModel =
        createModel(context, () => CreateDataListItemModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    blueprintDataEntryModel.dispose();
    nutrientDataEntryModel.dispose();
    climateConditionDataEntryModel.dispose();
    agrimethodDataEntryModel.dispose();
    localizeDataEntryModel.dispose();
    createDataListItemModel.dispose();
  }
}
