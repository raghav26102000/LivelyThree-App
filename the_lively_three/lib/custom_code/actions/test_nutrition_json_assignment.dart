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

import 'dart:convert';

Future<void> testNutritionJsonAssignment(dynamic nutrientBounds) async {
  // Print the raw input.
  print(
      "testNutritionJsonAssignment: Received nutrientBounds: $nutrientBounds");

  if (nutrientBounds == null) {
    print("testNutritionJsonAssignment: nutrientBounds is null.");
    return;
  }

  // Check the type of nutrientBounds.
  if (nutrientBounds is Map) {
    // The data is already a Map.
    print("testNutritionJsonAssignment: nutrientBounds is a Map.");
    // Print a properly formatted JSON string for debugging.
    String properJson = jsonEncode(nutrientBounds);
    print("testNutritionJsonAssignment: Proper JSON: $properJson");
  } else if (nutrientBounds is String) {
    // The data is a String; try to parse it.
    try {
      final Map<String, dynamic> parsed = jsonDecode(nutrientBounds);
      String properJson = jsonEncode(parsed);
      print("testNutritionJsonAssignment: Parsed JSON: $properJson");
    } catch (e, st) {
      print(
          "testNutritionJsonAssignment: ERROR decoding nutrientBounds: $e\n$st");
    }
  } else {
    print(
        "testNutritionJsonAssignment: nutrientBounds is of unsupported type: ${nutrientBounds.runtimeType}");
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
