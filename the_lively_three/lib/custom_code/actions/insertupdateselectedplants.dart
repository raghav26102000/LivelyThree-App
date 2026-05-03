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

Future<void> insertupdateselectedplants(String country, String userid) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Call the Supabase function
    final response = await supabaseClient.rpc(
      'insertupdateselectedplants',
      params: {'country': country, 'userid': userid},
    );

    // Handle the response (if necessary)
    print('Supabase function response: $response');
  } catch (error) {
    // Handle exceptions
    print('Unexpected error: $error');
  }
}
