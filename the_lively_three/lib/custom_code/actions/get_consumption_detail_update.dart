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

Future<void> getConsumptionDetailUpdate(
    int calendarWeek, String userId, int calendarYear) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Always clear the list first.
    FFAppState().weeklyConsumptionList.clear();

    // Call the RPC function.
    final data = await supabaseClient.rpc(
      'get_weekly_consumption_details',
      params: {
        '_calendarweek': calendarWeek,
        '_calendaryear': calendarYear,
        '_user_id': userId,
      },
    );

    // Check if data is valid
    if (data is List<dynamic> && data.isNotEmpty) {
      for (var row in data) {
        FFAppState().weeklyConsumptionList.add(
              WeeklyConsumptionDetailsSchemaStruct(
                week: row['week'] as int,
                calendarYear: row['year'] as int,
                plantname: row['plantname'] as String? ?? '',
                color: row['color'] as String? ?? '',
                day: row['day'] as String,
                portionPlant: (row['portion_plant'] as num?)?.toDouble() ?? 0.0,
                portionWater: row['portion_water'] as int? ?? 0,
                portionUpf: row['portion_upf'] as int? ?? 0,
                dateDay: row['date_day'] as int,
                dateMonth: row['date_month'] as int,
              ),
            );
      }
      print("Consumption details successfully updated: ${FFAppState().weeklyConsumptionList}");
    } else {
      print('No data returned from Supabase (list stays empty).');
    }
  } catch (error) {
    print('Unexpected error in getConsumptionDetailUpdate: $error');
  }
}
