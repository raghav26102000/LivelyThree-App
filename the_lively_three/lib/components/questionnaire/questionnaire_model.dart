import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'questionnaire_widget.dart'
    show DynamicFormFieldWidget, DynamicFormField;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DynamicFormFieldModel extends FlutterFlowModel<DynamicFormField> {
  ///  Local state fields for this component.
  /// To toggle the visibility of portion editing
  bool isEditingPortionSize = false;
  String heightUnit = 'cm';

  /// To toggle the visibility of weekly portion editing
  bool isEditingWeeklyPortionSize = false;

  int? portionSize;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM - EEE');
    return formatter.format(now);
  }
}
