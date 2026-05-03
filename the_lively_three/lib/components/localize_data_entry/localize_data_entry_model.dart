import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'localize_data_entry_widget.dart' show LocalizeDataEntryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LocalizeDataEntryModel extends FlutterFlowModel<LocalizeDataEntryWidget> {
  ///  Local state fields for this component.

  LocalizedplantRow? localizeDocument;

  List<String> listblueprintplants = [];
  void addToListblueprintplants(String item) => listblueprintplants.add(item);
  void removeFromListblueprintplants(String item) =>
      listblueprintplants.remove(item);
  void removeAtIndexFromListblueprintplants(int index) =>
      listblueprintplants.removeAt(index);
  void insertAtIndexInListblueprintplants(int index, String item) =>
      listblueprintplants.insert(index, item);
  void updateListblueprintplantsAtIndex(int index, Function(String) updateFn) =>
      listblueprintplants[index] = updateFn(listblueprintplants[index]);

  List<int> originindexlist = [];
  void addToOriginindexlist(int item) => originindexlist.add(item);
  void removeFromOriginindexlist(int item) => originindexlist.remove(item);
  void removeAtIndexFromOriginindexlist(int index) =>
      originindexlist.removeAt(index);
  void insertAtIndexInOriginindexlist(int index, int item) =>
      originindexlist.insert(index, item);
  void updateOriginindexlistAtIndex(int index, Function(int) updateFn) =>
      originindexlist[index] = updateFn(originindexlist[index]);

  List<int> agroindexlist = [];
  void addToAgroindexlist(int item) => agroindexlist.add(item);
  void removeFromAgroindexlist(int item) => agroindexlist.remove(item);
  void removeAtIndexFromAgroindexlist(int index) =>
      agroindexlist.removeAt(index);
  void insertAtIndexInAgroindexlist(int index, int item) =>
      agroindexlist.insert(index, item);
  void updateAgroindexlistAtIndex(int index, Function(int) updateFn) =>
      agroindexlist[index] = updateFn(agroindexlist[index]);

  List<int> climateindexlist = [];
  void addToClimateindexlist(int item) => climateindexlist.add(item);
  void removeFromClimateindexlist(int item) => climateindexlist.remove(item);
  void removeAtIndexFromClimateindexlist(int index) =>
      climateindexlist.removeAt(index);
  void insertAtIndexInClimateindexlist(int index, int item) =>
      climateindexlist.insert(index, item);
  void updateClimateindexlistAtIndex(int index, Function(int) updateFn) =>
      climateindexlist[index] = updateFn(climateindexlist[index]);

  List<int> blueprintindexlist = [];
  void addToBlueprintindexlist(int item) => blueprintindexlist.add(item);
  void removeFromBlueprintindexlist(int item) =>
      blueprintindexlist.remove(item);
  void removeAtIndexFromBlueprintindexlist(int index) =>
      blueprintindexlist.removeAt(index);
  void insertAtIndexInBlueprintindexlist(int index, int item) =>
      blueprintindexlist.insert(index, item);
  void updateBlueprintindexlistAtIndex(int index, Function(int) updateFn) =>
      blueprintindexlist[index] = updateFn(blueprintindexlist[index]);

  List<int> userregionindexlist = [];
  void addToUserregionindexlist(int item) => userregionindexlist.add(item);
  void removeFromUserregionindexlist(int item) =>
      userregionindexlist.remove(item);
  void removeAtIndexFromUserregionindexlist(int index) =>
      userregionindexlist.removeAt(index);
  void insertAtIndexInUserregionindexlist(int index, int item) =>
      userregionindexlist.insert(index, item);
  void updateUserregionindexlistAtIndex(int index, Function(int) updateFn) =>
      userregionindexlist[index] = updateFn(userregionindexlist[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for CheckboxGroup widget.
  FormFieldController<List<String>>? checkboxGroupValueController;
  List<String>? get checkboxGroupValues => checkboxGroupValueController?.value;
  set checkboxGroupValues(List<String>? v) =>
      checkboxGroupValueController?.value = v;

  // Stores action output result for [Backend Call - Query Rows] action in CheckboxGroup widget.
  List<BlueprintplantRow>? plantEntries;
  // State field(s) for userregion widget.
  List<int>? userregionValue;
  FormFieldController<List<int>>? userregionValueController;
  // State field(s) for plantorigin widget.
  List<int>? plantoriginValue;
  FormFieldController<List<int>>? plantoriginValueController;
  // State field(s) for agrimethod widget.
  List<int>? agrimethodValue;
  FormFieldController<List<int>>? agrimethodValueController;
  // State field(s) for climatecondition widget.
  List<int>? climateconditionValue;
  FormFieldController<List<int>>? climateconditionValueController;
  // Stores action output result for [Custom Action - insertLocalizedPlants] action in Button widget.
  bool? succes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
