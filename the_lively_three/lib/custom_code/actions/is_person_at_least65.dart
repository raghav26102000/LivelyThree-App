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
Future<bool> isPersonAtLeast65(DateTime birthday) async {
  // 1) Get the current date/time
  final now = DateTime.now();

  // 2) Calculate the rough difference in years
  int age = now.year - birthday.year;

  // 3) If the current date is before the birthday in this calendar year, subtract 1
  final birthdayThisYear = DateTime(now.year, birthday.month, birthday.day);
  if (now.isBefore(birthdayThisYear)) {
    age--;
  }

  // 4) Return true if age >= 65, false otherwise
  return age >= 65;
}
