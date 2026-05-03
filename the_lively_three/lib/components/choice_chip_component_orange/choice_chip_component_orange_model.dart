import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'choice_chip_component_orange_widget.dart'
    show ChoiceChipComponentOrangeWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoiceChipComponentOrangeModel
    extends FlutterFlowModel<ChoiceChipComponentOrangeWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for orangeChoiceChips widget.
  FormFieldController<List<String>>? orangeChoiceChipsValueController;
  List<String>? get orangeChoiceChipsValues =>
      orangeChoiceChipsValueController?.value;
  set orangeChoiceChipsValues(List<String>? val) =>
      orangeChoiceChipsValueController?.value = val;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
