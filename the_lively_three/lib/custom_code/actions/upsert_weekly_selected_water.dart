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

/// Custom Action to upsert (insert or update) the daily portion in 'weeklyselected_upf'.
/// Returns the new total for the day portion.
///
/// - [userId]: UUID string of the user.
/// - [calendarWeek]: Current calendar week number.
/// - [calendarYear]: Current calendar year.
/// - [dbCounter]: Number to increment the day's portion by (typically 1).
///
/// Returns:
/// - The updated count for the day portion if successful.
/// - `null` if there was an error.
Future<int?> upsertWeeklySelectedWater(
  String userId,
  int calendarWeek,
  int calendarYear,
  int dbCounter,
) async {
  final supabaseClient = Supabase.instance.client;

  // 1) Determine the correct day column based on the current weekday.
  final now = DateTime.now();
  final weekday = now.weekday; // Monday=1 .. Sunday=7

  late String dayColumn;
  switch (weekday) {
    case DateTime.monday:
      dayColumn = 'monportion';
      break;
    case DateTime.tuesday:
      dayColumn = 'tueportion';
      break;
    case DateTime.wednesday:
      dayColumn = 'wedportion';
      break;
    case DateTime.thursday:
      dayColumn = 'thuportion';
      break;
    case DateTime.friday:
      dayColumn = 'friportion';
      break;
    case DateTime.saturday:
      dayColumn = 'satportion';
      break;
    case DateTime.sunday:
      dayColumn = 'sunportion';
      break;
    default:
      throw Exception('Invalid weekday: $weekday');
  }

  try {
    // 2) Fetch existing row for the user/week/year.
    final existingRow = await supabaseClient
        .from('weeklyselected_water')
        .select('*') // Fetch all columns for easy manipulation
        .eq('id_user', userId)
        .eq('calendarweek', calendarWeek)
        .eq('calendaryear', calendarYear)
        .maybeSingle(); // Safely fetch single row or null

    if (existingRow == null) {
      // 3a) No existing row => Insert a new row with the day's portion set to 1.
      final newRow = {
        'id_user': userId,
        'calendarweek': calendarWeek,
        'calendaryear': calendarYear,
        'monportion': 0,
        'tueportion': 0,
        'wedportion': 0,
        'thuportion': 0,
        'friportion': 0,
        'satportion': 0,
        'sunportion': 0,
        'portionsum': dbCounter, // Initialize portionsum with dbCounter
      };

      // Set the specific day's portion to dbCounter (typically 1).
      newRow[dayColumn] = dbCounter;

      // 4. Insert the new row and get the inserted data.
      final insertResponse = await supabaseClient
          .from('weeklyselected_water')
          .insert(newRow)
          .select('*') // Retrieve the inserted row
          .single(); // Expect exactly one row

      if (insertResponse == null) {
        print('Insert Error: No data returned.');
        return null;
      }

      print('Inserted new row with $dayColumn: ${insertResponse[dayColumn]}');
      return insertResponse[dayColumn] as int? ?? 0;
    } else {
      // 3b) Existing row found => Increment the day's portion by dbCounter.
      Map<String, dynamic> updatedRow =
          Map<String, dynamic>.from(existingRow as Map<String, dynamic>);

      int currentCount = updatedRow[dayColumn] as int? ?? 0;
      int newCount = currentCount + dbCounter;

      updatedRow[dayColumn] = newCount;

      // Recompute portionsum.
      int sum = 0;
      for (var key in [
        'monportion',
        'tueportion',
        'wedportion',
        'thuportion',
        'friportion',
        'satportion',
        'sunportion',
      ]) {
        sum += (updatedRow[key] as int? ?? 0);
      }
      updatedRow['portionsum'] = sum;

      // 4. Upsert the updated row with onConflict.
      final upsertResponse = await supabaseClient
          .from('weeklyselected_water')
          .upsert(updatedRow, onConflict: 'id_user,calendarweek,calendaryear')
          .select('*') // Retrieve the upserted row
          .single(); // Expect exactly one row

      if (upsertResponse == null) {
        print('Upsert Error: No data returned.');
        return null;
      }

      print('Updated row with $dayColumn: ${upsertResponse[dayColumn]}');
      return upsertResponse[dayColumn] as int? ?? 0;
    }
  } catch (error) {
    print('Error in upsertWeeklySelectedWater: $error');
    return null;
  }
}
