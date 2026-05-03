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

/// Decrements the current day's portion by 1 in the 'weeklyselected_upf' table.
///
/// Parameters:
/// - [userId]: The UUID of the user.
/// - [calendarWeek]: The current calendar week number.
/// - [calendarYear]: The current calendar year.
///
/// Returns:
/// - The updated count for the day's portion as an integer if successful.
/// - `null` if an error occurs.
Future<int?> decrementWeeklySelectedWater(
  String userId,
  int calendarWeek,
  int calendarYear,
) async {
  final supabase = Supabase.instance.client;

  // Determine the current day's column based on the weekday.
  final now = DateTime.now();
  final weekday = now.weekday; // Monday=1 .. Sunday=7

  String dayColumn;
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
    // Fetch the existing row.
    final response = await supabase
        .from('weeklyselected_water')
        .select()
        .eq('id_user', userId)
        .eq('calendarweek', calendarWeek)
        .eq('calendaryear', calendarYear)
        .maybeSingle();

    if (response == null) {
      // Insert new row with day's portion set to 0.
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
        'portionsum': 0,
      };

      await supabase.from('weeklyselected_water').insert(newRow);

      print('Inserted new row with $dayColumn: 0');
      return 0;
    } else {
      // Existing row found. Decrement the day's portion.
      Map<String, dynamic> updatedRow =
          Map<String, dynamic>.from(response as Map<String, dynamic>);

      int currentCount = updatedRow[dayColumn] as int? ?? 0;
      int newCount = currentCount - 1;
      if (newCount < 0) newCount = 0;

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

      // Update the existing row.
      await supabase
          .from('weeklyselected_water')
          .update(updatedRow)
          .eq('id_user', userId)
          .eq('calendarweek', calendarWeek)
          .eq('calendaryear', calendarYear);

      print('Decremented $dayColumn to $newCount');
      return newCount;
    }
  } catch (e) {
    print('Error in decrementWeeklySelectedWater: $e');
    return null;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
