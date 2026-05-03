import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'create_data_list_item_widget.dart' show CreateDataListItemWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateDataListItemModel
    extends FlutterFlowModel<CreateDataListItemWidget> {
  ///  Local state fields for this component.

  List<String> listIndividualUserIndicators = [];
  void addToListIndividualUserIndicators(String item) =>
      listIndividualUserIndicators.add(item);
  void removeFromListIndividualUserIndicators(String item) =>
      listIndividualUserIndicators.remove(item);
  void removeAtIndexFromListIndividualUserIndicators(int index) =>
      listIndividualUserIndicators.removeAt(index);
  void insertAtIndexInListIndividualUserIndicators(int index, String item) =>
      listIndividualUserIndicators.insert(index, item);
  void updateListIndividualUserIndicatorsAtIndex(
          int index, Function(String) updateFn) =>
      listIndividualUserIndicators[index] =
          updateFn(listIndividualUserIndicators[index]);

  List<int> indIndicatorIndexList = [];
  void addToIndIndicatorIndexList(int item) => indIndicatorIndexList.add(item);
  void removeFromIndIndicatorIndexList(int item) =>
      indIndicatorIndexList.remove(item);
  void removeAtIndexFromIndIndicatorIndexList(int index) =>
      indIndicatorIndexList.removeAt(index);
  void insertAtIndexInIndIndicatorIndexList(int index, int item) =>
      indIndicatorIndexList.insert(index, item);
  void updateIndIndicatorIndexListAtIndex(int index, Function(int) updateFn) =>
      indIndicatorIndexList[index] = updateFn(indIndicatorIndexList[index]);

  int? contractId;

  List<ViewIndicatorsContractRow> contractindicatorlistupdate = [];
  void addToContractindicatorlistupdate(ViewIndicatorsContractRow item) =>
      contractindicatorlistupdate.add(item);
  void removeFromContractindicatorlistupdate(ViewIndicatorsContractRow item) =>
      contractindicatorlistupdate.remove(item);
  void removeAtIndexFromContractindicatorlistupdate(int index) =>
      contractindicatorlistupdate.removeAt(index);
  void insertAtIndexInContractindicatorlistupdate(
          int index, ViewIndicatorsContractRow item) =>
      contractindicatorlistupdate.insert(index, item);
  void updateContractindicatorlistupdateAtIndex(
          int index, Function(ViewIndicatorsContractRow) updateFn) =>
      contractindicatorlistupdate[index] =
          updateFn(contractindicatorlistupdate[index]);

  List<String> listSharedUserIndicators = [];
  void addToListSharedUserIndicators(String item) =>
      listSharedUserIndicators.add(item);
  void removeFromListSharedUserIndicators(String item) =>
      listSharedUserIndicators.remove(item);
  void removeAtIndexFromListSharedUserIndicators(int index) =>
      listSharedUserIndicators.removeAt(index);
  void insertAtIndexInListSharedUserIndicators(int index, String item) =>
      listSharedUserIndicators.insert(index, item);
  void updateListSharedUserIndicatorsAtIndex(
          int index, Function(String) updateFn) =>
      listSharedUserIndicators[index] =
          updateFn(listSharedUserIndicators[index]);

  List<int> sharedIndicatorIndexList = [];
  void addToSharedIndicatorIndexList(int item) =>
      sharedIndicatorIndexList.add(item);
  void removeFromSharedIndicatorIndexList(int item) =>
      sharedIndicatorIndexList.remove(item);
  void removeAtIndexFromSharedIndicatorIndexList(int index) =>
      sharedIndicatorIndexList.removeAt(index);
  void insertAtIndexInSharedIndicatorIndexList(int index, int item) =>
      sharedIndicatorIndexList.insert(index, item);
  void updateSharedIndicatorIndexListAtIndex(
          int index, Function(int) updateFn) =>
      sharedIndicatorIndexList[index] =
          updateFn(sharedIndicatorIndexList[index]);

  DatacontractRow? datacontractDocument;

  String? tempContractStatus;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<ViewUserConsentedIndicatorsRow>? consentedContractOutput;
  // State field(s) for status1 widget.
  String? status1Value;
  FormFieldController<String>? status1ValueController;
  // State field(s) for contractdescription1 widget.
  FocusNode? contractdescription1FocusNode;
  TextEditingController? contractdescription1TextController;
  String? Function(BuildContext, String?)?
      contractdescription1TextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<UsercontractsRow>? usercontractConsentCheckOutput;
  // State field(s) for contractname2 widget.
  FocusNode? contractname2FocusNode;
  TextEditingController? contractname2TextController;
  String? Function(BuildContext, String?)? contractname2TextControllerValidator;
  // State field(s) for contractdescription2 widget.
  FocusNode? contractdescription2FocusNode;
  TextEditingController? contractdescription2TextController;
  String? Function(BuildContext, String?)?
      contractdescription2TextControllerValidator;
  // State field(s) for contracttype2 widget.
  String? contracttype2Value;
  FormFieldController<String>? contracttype2ValueController;
  // State field(s) for validitytype2 widget.
  String? validitytype2Value;
  FormFieldController<String>? validitytype2ValueController;
  // State field(s) for status2 widget.
  String? status2Value;
  FormFieldController<String>? status2ValueController;
  // State field(s) for CheckboxgroupIndInd1 widget.
  FormFieldController<List<String>>? checkboxgroupIndInd1ValueController;
  List<String>? get checkboxgroupIndInd1Values =>
      checkboxgroupIndInd1ValueController?.value;
  set checkboxgroupIndInd1Values(List<String>? v) =>
      checkboxgroupIndInd1ValueController?.value = v;

  // Stores action output result for [Backend Call - Query Rows] action in CheckboxgroupIndInd1 widget.
  List<UserindicatorsRow>? indIndicatorsActionOutput;
  // State field(s) for CheckboxgroupSharedInd1 widget.
  FormFieldController<List<String>>? checkboxgroupSharedInd1ValueController;
  List<String>? get checkboxgroupSharedInd1Values =>
      checkboxgroupSharedInd1ValueController?.value;
  set checkboxgroupSharedInd1Values(List<String>? v) =>
      checkboxgroupSharedInd1ValueController?.value = v;

  // Stores action output result for [Backend Call - Query Rows] action in CheckboxgroupSharedInd1 widget.
  List<UserindicatorsRow>? sharedIndicatorsActionOutput;
  // Stores action output result for [Custom Action - insertdatacontracts] action in Button widget.
  String? contractnameactionoutput2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    contractdescription1FocusNode?.dispose();
    contractdescription1TextController?.dispose();

    contractname2FocusNode?.dispose();
    contractname2TextController?.dispose();

    contractdescription2FocusNode?.dispose();
    contractdescription2TextController?.dispose();
  }
}
