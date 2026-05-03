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

Future<dynamic> fetchTopTwoIndividualIndicatorValues(String userId) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // 1. Call the Postgres function
    final data = await supabaseClient.rpc(
      'fetch_top_two_individual_indicator_values',
      params: {'p_user_id': userId},
    );

    // 2. 'data' should be the final JSON structure returned by the PL/pgSQL function
    return data;
  } catch (error) {
    print('Error in fetchTopTwoIndividualIndicatorValues RPC: $error');

    // Return a fallback structure or empty object if desired
    return {
      'current_week': {'calendarweek': 0, 'calendaryear': 0, 'indicators': {}},
      'previous_week': {'calendarweek': 0, 'calendaryear': 0, 'indicators': {}}
    };
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
