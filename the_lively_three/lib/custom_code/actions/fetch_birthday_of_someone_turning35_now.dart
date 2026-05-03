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

@pragma('vm:entry-point')
Future<DateTime> fetchBirthdayOfSomeoneTurning35Now() async {
  // 1) Get the current local date/time.
  final now = DateTime.now();

  // 2) Construct a date that is exactly 35 years earlier, preserving month/day/time.
  final turning35Birthday = DateTime(
    now.year - 35,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );

  // 3) Return the calculated "birthday" date.
  return turning35Birthday;
}
