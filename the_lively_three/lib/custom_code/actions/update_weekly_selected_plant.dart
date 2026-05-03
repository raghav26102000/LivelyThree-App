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
import 'package:intl/intl.dart';

Future<void> updateWeeklySelectedPlant(
  String userId,
  int calendarWeek,
  int calendarYear,
  String plantname,
  String color,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Get the current day of the week
    final now = DateTime.now();
    final currentDayOfWeek = DateFormat('EEEE').format(now);

    // Map day to portion column
    final portionColumn = {
      'Monday': 'monportion',
      'Tuesday': 'tueportion',
      'Wednesday': 'wedportion',
      'Thursday': 'thuportion',
      'Friday': 'friportion',
      'Saturday': 'satportion',
      'Sunday': 'sunportion',
    }[currentDayOfWeek];

    if (portionColumn == null) {
      print('Invalid day of the week: $currentDayOfWeek');
      return;
    }

    // Fetch the existing row
    // In newer SDK versions, .maybeSingle() returns a Map<String, dynamic>? or null
    final existingRowResponse = await supabase
        .from('weeklyselectedplant')
        .select('*')
        .eq('id_user', userId)
        .eq('plantname', plantname)
        .eq('week', calendarWeek)
        .eq('year', calendarYear)
        .maybeSingle();

    if (existingRowResponse == null) {
      print(
          'No existing row found for user=$userId, plant=$plantname, week=$calendarWeek.');
      return;
    }

    // Calculate updated values
    final updatedData = {
      portionColumn: (existingRowResponse[portionColumn] ?? 0) + 1,
      'portionsum': (existingRowResponse['monportion'] ?? 0) +
          (existingRowResponse['tueportion'] ?? 0) +
          (existingRowResponse['wedportion'] ?? 0) +
          (existingRowResponse['thuportion'] ?? 0) +
          (existingRowResponse['friportion'] ?? 0) +
          (existingRowResponse['satportion'] ?? 0) +
          (existingRowResponse['sunportion'] ?? 0) +
          1,
    };

    // Update the row
    // In newer SDK versions, if there's an error, an exception is thrown
    final updateResponse = await supabase
        .from('weeklyselectedplant')
        .update(updatedData)
        .eq('id', existingRowResponse['id']);

    // updateResponse is typically a List of updated rows or null
    print('Row updated successfully. Response: $updateResponse');
  } on PostgrestException catch (error) {
    // If a Postgrest-specific exception occurs (e.g., RLS policy violation)
    print('PostgrestException in updateWeeklySelectedPlant: $error');
  } catch (error) {
    // Catch any other general exception
    print('Unexpected error in updateWeeklySelectedPlant: $error');
  }
}
