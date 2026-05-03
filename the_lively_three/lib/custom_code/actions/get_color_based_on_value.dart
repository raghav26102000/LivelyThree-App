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

Color getColorBasedOnValue(double value) {
  if (value <= 24) {
    return Color(0x8D0B41); // Red
  } else if (value <= 49) {
    return Color(0xFEB5B00); // Orange
  } else if (value <= 74) {
    return Color(0xE9C874); // Yellow
  } else {
    return Color(0x3E7B27); // Green
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
