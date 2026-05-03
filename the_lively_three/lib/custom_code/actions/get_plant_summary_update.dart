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
// import '../flutter_flow/flutter_flow_util.dart'; // or wherever FFAppState is defined

@pragma('vm:entry-point')
Future<void> getPlantSummaryUpdate(
    int calendarWeek, int calendarYear, String userId) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // 1) Call the Supabase RPC function
    final data = await supabaseClient.rpc(
      'get_weekly_user_consumption',
      params: {
        'user_id': userId,
        'calendarweek': calendarWeek,
        'calendaryear': calendarYear,
      },
    );

    // data should be a List<dynamic> with either one row or empty
    if (data is List && data.isNotEmpty) {
      final row = data.first; // We'll parse the first row

      // 2) Build your custom struct from row columns
      //    Adjust field names if your struct differs.
      final newSummary = PlantsSummarySchemaStruct(
        totalDistinctPlantsSelected:
            (row['total_distinct_plants'] as int?) ?? 0,
        totalDistinctPlantsConsumed:
            (row['total_distinct_plants_consumed'] as int?) ?? 0,

        totalPlantsSelectedRedConsumed:
            (row['total_plants_selected_red_consumed'] as int?) ?? 0,
        totalPlantsSelectedOrangeConsumed:
            (row['total_plants_selected_orange_consumed'] as int?) ?? 0,
        totalPlantsSelectedYellowConsumed:
            (row['total_plants_selected_yellow_consumed'] as int?) ?? 0,
        totalPlantsSelectedGreenConsumed:
            (row['total_plants_selected_green_consumed'] as int?) ?? 0,
        totalPlantsSelectedPurpleConsumed:
            (row['total_plants_selected_purple_consumed'] as int?) ?? 0,
        totalPlantsSelectedBrownConsumed:
            (row['total_plants_selected_brown_consumed'] as int?) ?? 0,
        totalPlantsSelectedWhiteConsumed:
            (row['total_plants_selected_white_consumed'] as int?) ?? 0,

        colorsConsumed: (row['colors_consumed'] as int?) ?? 0,

        plantsConsumedMonday: (row['consumed_plants_monday'] as int?) ?? 0,
        plantsConsumedTuesday: (row['consumed_plants_tuesday'] as int?) ?? 0,
        plantsConsumedWednesday:
            (row['consumed_plants_wednesday'] as int?) ?? 0,
        plantsConsumedThursday: (row['consumed_plants_thursday'] as int?) ?? 0,
        plantsConsumedFriday: (row['consumed_plants_friday'] as int?) ?? 0,
        plantsConsumedSaturday: (row['consumed_plants_saturday'] as int?) ?? 0,
        plantsConsumedSunday: (row['consumed_plants_sunday'] as int?) ?? 0,

        totalPortionsMonday:
            (row['total_portions_monday'] as num?)?.toDouble() ?? 0.0,
        totalPortionsTuesday:
            (row['total_portions_tuesday'] as num?)?.toDouble() ?? 0.0,
        totalPortionsWednesday:
            (row['total_portions_wednesday'] as num?)?.toDouble() ?? 0.0,
        totalPortionsThursday:
            (row['total_portions_thursday'] as num?)?.toDouble() ?? 0.0,
        totalPortionsFriday:
            (row['total_portions_friday'] as num?)?.toDouble() ?? 0.0,
        totalPortionsSaturday:
            (row['total_portions_saturday'] as num?)?.toDouble() ?? 0.0,
        totalPortionsSunday:
            (row['total_portions_sunday'] as num?)?.toDouble() ?? 0.0,

        plantsperdayCounter: (row['day_counter'] as int?) ?? 0, // or dayCounter
        dayOfWeek: (row['current_day_of_week'] as int?) ?? 0,
      );

      // 3) Assign to your FFAppState variable
      //    e.g., FFAppState().plantSummary = newSummary;
      FFAppState().plantSummary = newSummary;

      print("Plant Summary updated in FFAppState: $newSummary");
    } else {
      print('No data returned from Supabase for getPlantSummaryUpdate.');
      // Optionally reset or set to defaults
      FFAppState().plantSummary = PlantsSummarySchemaStruct(); // empty fallback
    }
  } catch (error) {
    // Log unexpected errors
    print('Unexpected error in getPlantSummaryUpdate: $error');
    // Possibly reset state or do nothing
    FFAppState().plantSummary = PlantsSummarySchemaStruct();
  }
}
