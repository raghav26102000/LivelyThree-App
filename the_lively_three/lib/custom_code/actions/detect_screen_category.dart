// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<void> detectScreenCategory(BuildContext context) async {
  final width = MediaQuery.of(context).size.width;

  String screenCategory;
  if (width < 361) {
    screenCategory = 'small'; // Small devices
  } else if (width <= 400) {
    screenCategory = 'medium'; // Medium devices
  } else {
    screenCategory = 'large'; // Large devices
  }

  // Update the App State variable
  FFAppState().screenCategory = screenCategory;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
