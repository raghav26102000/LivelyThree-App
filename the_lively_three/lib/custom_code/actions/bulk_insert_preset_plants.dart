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

@pragma('vm:entry-point')
Future bulkInsertPresetPlants(
  String userId,
  String calendarWeek,
  String calenderYear,
  String presset,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Convert the string parameters for week/year to int if the DB function expects integers
    final cw = int.parse(calendarWeek);
    final yr = int.parse(calenderYear);

    // Call the Supabase RPC function that does the bulk insert
    await supabase.rpc(
      'bulk_insert_preset_plants',
      params: {
        '_user_id': userId,
        '_cw': cw,
        '_yr': yr,
        '_preset': presset,
      },
    );

    print(
        "bulkInsertPresetPlants completed successfully for user=$userId, preset=$presset.");
  } catch (e) {
    print("Error in bulkInsertPresetPlants: $e");
  }
}
