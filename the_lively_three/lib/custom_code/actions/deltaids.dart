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

List<int> deltaids(
  List<int> nutrientList,
  List<int> plantnutrientList,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  final missingIDs = <int>{};

  for (final nutrient in nutrientList) {
    // Check if ID exists in plant nutrient list
    if (!plantnutrientList.any((plantNutrient) => plantNutrient == nutrient)) {
      missingIDs.add(nutrient);
    }
  }

  return missingIDs.toList();

  /// MODIFY CODE ONLY ABOVE THIS LINE
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
