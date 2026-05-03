import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/other_consumption/other_consumption_widget.dart';
import 'package:the_lively_three/pages/sign_up/sign_up_widget.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  late BottomNavbarModel bottomNavbarModel;

  // Password visibility states
  late bool passwordVisibility;
  late bool confirmPasswordVisibility;

  // Text controllers (optional - can be managed in widget)
  TextEditingController? passwordTextController;
  TextEditingController? passwordCreateTextController;
  TextEditingController? emailAddressTextController;
  TextEditingController? emailAddressCreateTextController; // Add this one too
  TextEditingController? passwordConfirmTextController; // Add this one

  // Validator functions
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  // Signup data properties
  String signupEmail = '';
  String signupPassword = '';
  String signupPasswordConfirm = '';

  // API response properties
  dynamic sendVerificationEmailOutput;
  bool? hasSuccess;
  String errorMessage = '';

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    confirmPasswordVisibility = false;
    bottomNavbarModel = createModel(context, () => BottomNavbarModel());

    // Initialize text controllers if needed
    emailAddressCreateTextController = TextEditingController();
    passwordCreateTextController = TextEditingController();
    passwordConfirmTextController = TextEditingController();
  }

  @override
  void dispose() {
    bottomNavbarModel.dispose();

    // Dispose text controllers
    emailAddressCreateTextController?.dispose();
    passwordCreateTextController?.dispose();
    passwordConfirmTextController?.dispose();
    passwordTextController?.dispose();
    emailAddressTextController?.dispose();
  }

  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM - EEE');
    return formatter.format(now);
  }
}

class Validators {
  static String? validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]+$');
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static int scorePassword(String pwd) {
    if (pwd.isEmpty) return 0;
    int score = 0;

    final hasLower = RegExp(r'[a-z]').hasMatch(pwd);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(pwd);
    final hasDigit = RegExp(r'\d').hasMatch(pwd);
    final hasSpecial =
        RegExp('[!@#\$%^&*()\\-_=+{}\\[\\]\\\\|;:\'",<.>/?`~]').hasMatch(pwd);
    final len = pwd.length;

    if (len >= 8) score++;
    if (len >= 10) score++;

    final varieties =
        <bool>[hasLower, hasUpper, hasDigit, hasSpecial].where((b) => b).length;
    if (varieties >= 2) score++;
    if (varieties >= 3) score++;

    if (len < 8 || varieties < 2) return 0; // Weak
    if (score >= 4) return 2; // Strong
    return 1; // Medium
  }

  static String? validatePassword(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters required';

    final categories = <bool>[
      RegExp(r'[a-z]').hasMatch(v),
      RegExp(r'[A-Z]').hasMatch(v),
      RegExp(r'\d').hasMatch(v),
      RegExp('[!@#\$%^&*()\\-_=+{}\\[\\]\\\\|;:\'",<.>/?`~]').hasMatch(v),
    ].where((b) => b).length;

    if (categories < 2) {
      return 'Use at least TWO of: lowercase, UPPERCASE, number, special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    final v = (value ?? '').trim();
    final p = password.trim();
    if (v.isEmpty) return 'Please confirm your password';
    if (v != p) return 'Passwords do not match';
    return null;
  }

  static String describeStrength(int score) {
    switch (score) {
      case 2:
        return 'Strong';
      case 1:
        return 'Medium';
      default:
        return 'Weak';
    }
  }

  static Color strengthColor(BuildContext context, int score) {
    switch (score) {
      case 2:
        return Colors.green;
      case 1:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
