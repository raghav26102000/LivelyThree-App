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

Future<bool?> updateSelectedPlants(
  List<String> choiceChipList,
  String color,
  String user,
  int currentWeek,
) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Fetch existing selected plants
    // - In newer SDK versions, this directly returns a List<dynamic> of rows, or throws an exception on error.
    final existingSelectedPlantsResponse = await supabaseClient
        .from('selectedplant')
        .select()
        .eq('color', color)
        .eq('id_user', user);

    // Since `select()` returns a List<dynamic>, we can directly check if it's empty
    if (existingSelectedPlantsResponse.isEmpty) {
      print('No existing plants found for the user and color combination.');
      return false;
    }

    // existingSelectedPlantsResponse is already a List<dynamic>
    final existingSelectedPlants = existingSelectedPlantsResponse;

    // Create a set of plant labels for efficient lookup
    final selectedPlantLabels = choiceChipList.toSet();

    // Variables to capture the change
    int? changedId;
    bool? changedStatus;
    String? changedPlantname;

    // Compare current state with the new choiceChipList
    for (var plant in existingSelectedPlants) {
      final isSelected = selectedPlantLabels.contains(plant['plantname']);

      if (plant['selected'] != isSelected) {
        // Detected a change
        changedId = plant['id'] as int;
        changedPlantname = plant['plantname'] as String;
        changedStatus = isSelected;
      }
    }

    // If no changes were detected, just return
    if (changedId == null) {
      print('No changes detected');
      return null;
    }

    // Update existing selected plants
    final updatedPlants = existingSelectedPlants.map((plant) {
      final isSelected = selectedPlantLabels.contains(plant['plantname']);
      return {
        'id': plant['id'],
        'selected': isSelected,
      };
    }).toList();

    // In newer SDK versions, `upsert()` doesn't return data by default.
    // We chain `.select()` to fetch the updated rows as the response.
    final updateResponse = await supabaseClient
        .from('selectedplant')
        .upsert(updatedPlants)
        .select(); // <-- Request the updated rows

    // `updateResponse` is now a List<dynamic> of updated rows.
    // If it's empty, that means no rows were updated.
    if (updateResponse.isEmpty) {
      print('Error updating selected plants. No rows returned.');
      return false;
    }

    // Call the Supabase function for creating or deleting rows in weeklyselectedplant
    // This should return data or throw an exception if something goes wrong.
    try {
      final rpcResponse =
          await supabaseClient.rpc('update_weekly_plantnames', params: {
        'calendarweek': currentWeek,
        'user_id': user,
      });

      // `rpcResponse` might contain some data depending on the function's return.
      // Print it to verify.
      print('RPC Response: $rpcResponse');
      return true;
    } catch (rpcError) {
      print('Error calling RPC: $rpcError');
      return false;
    }
  } catch (error) {
    // Catch any unexpected errors from the queries
    print('Unexpected error in updateSelectedPlants: $error');
    return false;
  }
}
