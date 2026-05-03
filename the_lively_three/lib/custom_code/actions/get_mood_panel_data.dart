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

Future<dynamic?> getMoodPanelData(
  int calendarYear,
  int calendarWeek,
  int weekday,
  String userId,
) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Query the Supabase database
    final data = await supabaseClient
        .from('weeklyselected_moodpanel')
        .select()
        .eq('calendaryear', calendarYear)
        .eq('calendarweek', calendarWeek)
        .eq('weekday', weekday)
        .eq('id_user', userId)
        .maybeSingle(); // Use maybeSingle to avoid throwing on multiple/no rows

    // If no data is found, return a structure with null values
    if (data == null) {
      final emptyResult = <String, dynamic>{
        'weekday': weekday,
        'calendarweek': calendarWeek,
        'calendaryear': calendarYear,
      };
      for (int i = 1; i <= 12; i++) {
        emptyResult['period_$i'] = null;
      }
      return emptyResult;
    }

    // Prepare the result structure
    final result = <String, dynamic>{
      'weekday': data['weekday'] ?? weekday,
      'calendarweek': data['calendarweek'] ?? calendarWeek,
      'calendaryear': data['calendaryear'] ?? calendarYear,
    };
    for (int i = 1; i <= 12; i++) {
      final periodKey = 'period_$i';
      final periodData = data[periodKey];

      // Safely add the color string or null to the result
      result[periodKey] = periodData is Map<String, dynamic>
          ? periodData['color'] as String?
          : null;
    }

    return result;
  } catch (error) {
    print('Unexpected error in getMoodPanelData: $error');

    // Return an empty structure for all periods in case of error
    final emptyResult = <String, dynamic>{
      'weekday': weekday,
      'calendarweek': calendarWeek,
      'calendaryear': calendarYear,
    };
    for (int i = 1; i <= 12; i++) {
      emptyResult['period_$i'] = null;
    }
    return emptyResult;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
