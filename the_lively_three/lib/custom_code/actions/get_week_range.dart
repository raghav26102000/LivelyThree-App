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

import 'package:intl/intl.dart';

/// Calculates the ISO 8601 week number and year from `inputDate` and
/// returns a formatted week range string.
String getWeekRange() {
  // Use the current date. For testing, you can hard-code a date.
  DateTime today = DateTime.now();
  print('Today: $today');

  // 1) Identify the Thursday of the current ISO week that `inputDate` falls in
  // ISO 8601 defines the week as starting on Monday and the week containing Thursday as the current week.
  // Thus, calculate the Thursday of the current week.
  DateTime thursday = today.add(Duration(days: 4 - today.weekday));

  // Adjust for cases where the weekday is Friday, Saturday, or Sunday
  if (today.weekday > DateTime.thursday) {
    thursday =
        today.subtract(Duration(days: today.weekday - DateTime.thursday));
  }

  // 2) Determine the ISO week year based on the calculated Thursday's year
  int isoWeekYear = thursday.year;

  // 3) Find the first Thursday of the ISO week year
  DateTime firstThursday = DateTime(isoWeekYear, 1, 4);
  int firstWeekDay = firstThursday.weekday;
  int shift = 4 - firstWeekDay; // 4 represents Thursday
  firstThursday = firstThursday.add(Duration(days: shift));

  // 4) Calculate the difference in days and compute the provisional week number
  int dayDifference = thursday.difference(firstThursday).inDays;
  int weekNumber = (dayDifference ~/ 7) + 1;

  // 5) Handle cases where weekNumber < 1 (belongs to the previous ISO year)
  if (weekNumber < 1) {
    isoWeekYear -= 1;
    firstThursday = DateTime(isoWeekYear, 1, 4);
    firstWeekDay = firstThursday.weekday;
    shift = 4 - firstWeekDay;
    firstThursday = firstThursday.add(Duration(days: shift));
    dayDifference = thursday.difference(firstThursday).inDays;
    weekNumber = (dayDifference ~/ 7) + 1;
  }

  // 6) Calculate total weeks in the ISO year (52 or 53)
  // The last Thursday of the year determines the total number of weeks
  DateTime lastThursday = DateTime(
      isoWeekYear, 12, 28); // December 28th is always in the last ISO week
  int totalWeeks = ((lastThursday.difference(firstThursday).inDays) ~/ 7) + 1;

  // 7) If weekNumber exceeds totalWeeks, assign to week 1 of the next ISO year
  if (weekNumber > totalWeeks) {
    isoWeekYear += 1;
    weekNumber = 1;
    firstThursday = DateTime(isoWeekYear, 1, 4);
    firstWeekDay = firstThursday.weekday;
    shift = 4 - firstWeekDay;
    firstThursday = firstThursday.add(Duration(days: shift));
  }

  print('ISO Year: $isoWeekYear, Week Number: $weekNumber');

  // 8) Find Monday of that ISO year
  DateTime firstMonday = _getFirstMondayOfISOYear(isoWeekYear);

  // 9) Monday of the "weekNumber"-th ISO week
  DateTime startDate = firstMonday.add(Duration(days: (weekNumber - 1) * 7));
  DateTime endDate = startDate.add(Duration(days: 6));

  // 10) Format output
  final DateFormat fmt = DateFormat('dd MMM yyyy');
  String formattedStart = fmt.format(startDate);
  String formattedEnd = fmt.format(endDate);

  String weekRange = 'Week $weekNumber ($formattedStart - $formattedEnd)';
  return weekRange;
}

/// Helper function to find the first Monday of the ISO year.
DateTime _getFirstMondayOfISOYear(int isoWeekYear) {
  // ISO 8601: The first week of the year is the one that contains the first Thursday of the year.
  // Thus, find the Monday of the week containing January 4th.
  DateTime jan4 = DateTime(isoWeekYear, 1, 4);
  int shift = DateTime.monday - jan4.weekday;
  DateTime firstMonday = jan4.add(Duration(days: shift));
  return firstMonday;
}
