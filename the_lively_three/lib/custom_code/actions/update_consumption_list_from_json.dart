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

class WeeklyConsumptionDetailsSchema {
  final int week;
  final int calendarYear;
  final String plantname;
  final String color;
  final String day;
  final double portionPlant; // Updated to double to allow fractions
  final int portionWater;
  final int portionUpf;
  final int dateDay;
  final int dateMonth;

  WeeklyConsumptionDetailsSchema({
    required this.week,
    required this.calendarYear,
    required this.plantname,
    required this.color,
    required this.day,
    required this.portionPlant,
    required this.portionWater,
    required this.portionUpf,
    required this.dateDay,
    required this.dateMonth,
  });
}

Future<void> updateConsumptionListFromJson(
    List<dynamic> weeklyConsumptionDetails) async {
  // Receive a nested Supabase JSON (week (int) as top level;
  // day (string), dateDay (int), dateMonth (int) next level;
  // "plantname" (string), "color" (string),
  // "portion_plant" (float), "portion_water" (int), "portion_upf" (int) as innermost level)
  // Transform it into custom data type for further processing.

  // Clear the existing list
  FFAppState().weeklyConsumptionList.clear();

  // Iterate through the JSON list
  for (var item in weeklyConsumptionDetails) {
    // Map each item to the custom data type
    final consumptionDetail = WeeklyConsumptionDetailsSchema(
      week: item['week'] as int,
      calendarYear: item['year'] as int,
      plantname: item['plantname'] as String? ?? '',
      color: item['color'] as String? ?? '',
      day: item['day'] as String,
      portionPlant: (item['portion_plant'] as num?)?.toDouble() ??
          0.0, // Ensure float values
      portionWater: item['portion_water'] as int? ?? 0,
      portionUpf: item['portion_upf'] as int? ?? 0,
      dateDay: item['date_day'] as int,
      dateMonth: item['date_month'] as int,
    );

    print(consumptionDetail);

    // Add to app state variable list
    FFAppState()
        .weeklyConsumptionList
        .add(consumptionDetail as WeeklyConsumptionDetailsSchemaStruct);
  }
}
