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

bool isWithinTimeWindow() {
  final now = DateTime.now().toUtc(); // Get current time in UTC
  final int currentHour = now.hour;
  final int currentMinute = now.minute;

  // Check if the time is between 23:55 and 00:05 UTC
  if ((currentHour == 23 && currentMinute >= 55) ||
      (currentHour == 0 && currentMinute <= 5)) {
    return true;
  } else {
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
