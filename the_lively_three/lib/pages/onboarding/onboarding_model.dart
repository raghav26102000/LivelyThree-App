import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  ///  Local state fields for this page.

  bool isExploratory = false;

  bool? isOlderThan65 = false;

  int height = 170;
  String? heightUnit;

  double weight = 65.0;

  String? weightUnit;

  String primaryGoal = 'n/a';

  String secondaryGoal = 'n/a';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - fetchBirthdayOfSomeoneTurning35Now] action in Onboarding widget.
  DateTime? defaultBirthdayOutput;
  // State field(s) for OnboardingPageView widget.
  PageController? onboardingPageViewController;

  int get onboardingPageViewCurrentIndex =>
      onboardingPageViewController != null &&
              onboardingPageViewController!.hasClients &&
              onboardingPageViewController!.page != null
          ? onboardingPageViewController!.page!.round()
          : 0;
  // State field(s) for GenderDropDown widget.
  String? genderDropDownValue;
  FormFieldController<String>? genderDropDownValueController;
  DateTime? datePicked;
  // State field(s) for HeightTextField widget.
  FocusNode? heightTextFieldFocusNode;
  TextEditingController? heightTextFieldTextController;
  String? Function(BuildContext, String?)?
      heightTextFieldTextControllerValidator;
  // State field(s) for WeightTextField widget.
  FocusNode? weightTextFieldFocusNode;
  TextEditingController? weightTextFieldTextController;
  String? Function(BuildContext, String?)?
      weightTextFieldTextControllerValidator;
  // Stores action output result for [Custom Action - isPersonAtLeast65] action in Button widget.
  bool? isPersonAtLeast65Output;
  // State field(s) for HealthyQuantityDropDown widget.
  String? healthyQuantityDropDownValue;
  FormFieldController<String>? healthyQuantityDropDownValueController;
  // State field(s) for NewFoodsDropDown widget.
  String? newFoodsDropDownValue;
  FormFieldController<String>? newFoodsDropDownValueController;
  // State field(s) for VarietyFoodDropDown widget.
  String? varietyFoodDropDownValue;
  FormFieldController<String>? varietyFoodDropDownValueController;
  // State field(s) for ActivityLevelDropDown widget.
  String? activityLevelDropDownValue;
  FormFieldController<String>? activityLevelDropDownValueController;
  // State field(s) for ChangeReadinessDropDown widget.
  String? changeReadinessDropDownValue;
  FormFieldController<String>? changeReadinessDropDownValueController;
  // State field(s) for ChangeToDropDown widget.
  String? changeToDropDownValue;
  FormFieldController<String>? changeToDropDownValueController;
  // State field(s) for PrimaryGoalDropDown widget.
  String? primaryGoalDropDownValue;
  FormFieldController<String>? primaryGoalDropDownValueController;
  // State field(s) for SecondaryGoalDropDown widget.
  String? secondaryGoalDropDownValue;
  FormFieldController<String>? secondaryGoalDropDownValueController;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<PlantpresetconfigurationRow>? plantpresetconfigOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    heightTextFieldFocusNode?.dispose();
    heightTextFieldTextController?.dispose();

    weightTextFieldFocusNode?.dispose();
    weightTextFieldTextController?.dispose();
  }
}
