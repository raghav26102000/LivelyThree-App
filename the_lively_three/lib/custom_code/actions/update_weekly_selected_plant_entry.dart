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

/// 1) Calls the `update_weeklyselectedplant_entry` function, which now returns no value.
/// 2) Then queries the `weeklyselectedplant` table to count how many rows match:
///    - id_user = [userId]
///    - color   = [color]
///    - week    = [calendarWeek]
///
/// Returns the count or null if an error occurs.
Future<int?> updateWeeklySelectedPlantEntry(
  int calendarWeek,
  int calendarYear,
  String userId,
  bool selected,
  int locId,
  String plantName,
  String color,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Step 1: Call the RPC function (no return value needed).
    await supabase.rpc(
      'update_weeklyselectedplant_entry',
      params: {
        'calendarweek': calendarWeek,
        'calendaryear': calendarYear,
        'user_id': userId,
        'selected': selected,
        'loc_id': locId,
        'input_plantname': plantName,
        'color': color,
      },
    );

    // Step 2: Query the table for rows matching (userId, color, calendarWeek).
    // 'select()' returns a List<dynamic> if successful, or throws an exception on error.
    final rows = await supabase
        .from('weeklyselectedplant')
        .select()
        .eq('id_user', userId)
        .eq('color', color)
        .eq('week', calendarWeek)
        .eq('year', calendarYear);

    // If rows is a List, we can use .length to get the count.
    if (rows is List) {
      return rows.length;
    }

    // Otherwise, handle any unexpected response format
    print('Unexpected result from color count query: $rows');
    return null;
  } catch (e) {
    // On any error (network, RLS, etc.), we catch the exception and return null
    print('Error calling updateWeeklySelectedPlantEntry: $e');
    return null;
  }
}
