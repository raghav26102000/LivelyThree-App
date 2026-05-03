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

Future<List<int>> getIdxfromLabelList(
    List<String> blueprintPlantLabelsList) async {
  // Retrieve the Supabase client
  final supabaseClient = Supabase.instance.client;

  try {
    // Query the "blueprintplant" table for matching names
    final response = await supabaseClient
        .from('blueprintfooditem')
        .select('id')
        .inFilter('name', blueprintPlantLabelsList);

    if (response.isEmpty) {
      print('No matching labels found.');
      return [];
    }

    // Extract the list of IDs from the response
    final List<int> idList =
        (response as List<dynamic>).map((e) => e['id'] as int).toList();

    return idList;
  } catch (error) {
    print('Unexpected error: $error');
    return [];
  }
}
