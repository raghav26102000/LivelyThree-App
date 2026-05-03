import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'choice_chip_component_green_widget.dart'
    show ChoiceChipComponentGreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoiceChipComponentGreenModel
    extends FlutterFlowModel<ChoiceChipComponentGreenWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for greenChoiceChips widget.
  FormFieldController<List<String>>? greenChoiceChipsValueController;
  List<String>? get greenChoiceChipsValues =>
      greenChoiceChipsValueController?.value;
  set greenChoiceChipsValues(List<String>? val) =>
      greenChoiceChipsValueController?.value = val;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
