import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'choice_chip_component_purple_widget.dart'
    show ChoiceChipComponentPurpleWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoiceChipComponentPurpleModel
    extends FlutterFlowModel<ChoiceChipComponentPurpleWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for purpleChoiceChips widget.
  FormFieldController<List<String>>? purpleChoiceChipsValueController;
  List<String>? get purpleChoiceChipsValues =>
      purpleChoiceChipsValueController?.value;
  set purpleChoiceChipsValues(List<String>? val) =>
      purpleChoiceChipsValueController?.value = val;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
