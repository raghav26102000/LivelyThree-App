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

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

Future<void> getNutrientBoundsLocalizedSelection(
    int idLoc, String idUser, int week, int year) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Call the RPC function.
    final data = await supabaseClient.rpc(
      'calculate_nutritive_bounds_localized_plants',
      params: {
        'p_id_loc': idLoc,
        'p_id_user': idUser,
        'p_week': week,
        'p_year': year,
      },
    );

    if (data == null) {
      throw Exception('No data returned from calculate_nutritive_bounds.');
    }

    // Map the JSON data to your custom data type.
    final nutrientBounds = NutrientBoundDataTypeStruct(
      // Note the new top-level key "inthirdrule".
      inThirdRule: data['inthirdrule'] as bool? ?? false,

      // Fiber fields:
      fiberLower: (data['fiber']['lower'] as num?)?.toDouble() ?? 0.0,
      fiberActual: (data['fiber']['actual'] as num?)?.toDouble() ?? 0.0,
      fiberUpper: (data['fiber']['upper'] as num?)?.toDouble() ?? 0.0,
      fiberRating: data['fiber']['rating'] as int? ?? 0,
      fiberPlantLower: data['fiber']['lower_name'] as String? ?? '',
      fiberPlantUpper: data['fiber']['upper_name'] as String? ?? '',
      fiberValueReference: data['fiber']['reference'] as String? ?? '',

      // Carbohydrate fields:
      carbsLower: (data['carbohydrate']['lower'] as num?)?.toDouble() ?? 0.0,
      carbsActual: (data['carbohydrate']['actual'] as num?)?.toDouble() ?? 0.0,
      carbsUpper: (data['carbohydrate']['upper'] as num?)?.toDouble() ?? 0.0,
      carbsPlantLower: data['carbohydrate']['lower_name'] as String? ?? '',
      carbsPlantUpper: data['carbohydrate']['upper_name'] as String? ?? '',
      carbsValueReference: data['carbohydrate']['reference'] as String? ?? '',

      // Protein fields:
      proteinLower: (data['protein']['lower'] as num?)?.toDouble() ?? 0.0,
      proteinActual: (data['protein']['actual'] as num?)?.toDouble() ?? 0.0,
      proteinUpper: (data['protein']['upper'] as num?)?.toDouble() ?? 0.0,
      proteinRating: data['protein']['rating'] as int? ?? 0,
      proteinPlantLower: data['protein']['lower_name'] as String? ?? '',
      proteinPlantUpper: data['protein']['upper_name'] as String? ?? '',
      proteinValueReference: data['protein']['reference'] as String? ?? '',

      // Fat fields:
      fatLower: (data['fat']['lower'] as num?)?.toDouble() ?? 0.0,
      fatActual: (data['fat']['actual'] as num?)?.toDouble() ?? 0.0,
      fatUpper: (data['fat']['upper'] as num?)?.toDouble() ?? 0.0,
      fatPlantLower: data['fat']['lower_name'] as String? ?? '',
      fatPlantUpper: data['fat']['upper_name'] as String? ?? '',
      fatValueReference: data['fat']['reference'] as String? ?? '',
    );

    print("Nutritive bounds updated successfully: ${jsonEncode(data)}");

    // Assign to the global app state variable.
    FFAppState().nutrientBounds = nutrientBounds;
  } catch (e) {
    print("Error in updateNutrientBounds: $e");

    // Assign a fallback structure in case of error.
    FFAppState().nutrientBounds = NutrientBoundDataTypeStruct(
      inThirdRule: false,
      fiberLower: 0.0,
      fiberActual: 0.0,
      fiberUpper: 0.0,
      fiberRating: 0,
      fiberPlantLower: '',
      fiberPlantUpper: '',
      fiberValueReference: '',
      carbsLower: 0.0,
      carbsActual: 0.0,
      carbsUpper: 0.0,
      carbsPlantLower: '',
      carbsPlantUpper: '',
      carbsValueReference: '',
      proteinLower: 0.0,
      proteinActual: 0.0,
      proteinUpper: 0.0,
      proteinRating: 0,
      proteinPlantLower: '',
      proteinPlantUpper: '',
      proteinValueReference: '',
      fatLower: 0.0,
      fatActual: 0.0,
      fatUpper: 0.0,
      fatPlantLower: '',
      fatPlantUpper: '',
      fatValueReference: '',
    );
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
