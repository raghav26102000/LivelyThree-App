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

Future<void> initializeWeeklySelectedPlants(
  String user,
  int calendarweek,
  int calendaryear,
) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // In newer Supabase SDKs, if there's an error, an exception is thrown.
    // If it's successful, you might get data (or null if the function returns void).
    final response = await supabaseClient.rpc(
      'initialize_weeklyselectedplants',
      params: {
        'p_user_id': user,
        'calendar_week': calendarweek,
        'calendar_year': calendaryear
      },
    );

    // If the function returns void, 'response' may be null or an empty list.
    // Just print out whatever it is for debugging:
    print('RPC response: $response');

    // Indicate success
    print('Weekly selected plants initialized successfully.');
  } catch (error) {
    // If there's a Supabase or network error, it throws an exception.
    print('Unexpected error in initializeWeeklySelectedPlants: $error');
  }
}
