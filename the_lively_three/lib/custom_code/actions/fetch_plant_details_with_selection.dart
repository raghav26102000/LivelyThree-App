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

Future<void> fetchPlantDetailsWithSelection(
  int calendarWeek,
  String userId,
  int calendarYear,
  String plantPreset,
) async {
  final supabaseClient = Supabase.instance.client;

  try {
    FFAppState().locplantselectionlist.clear();

    final data = await supabaseClient.rpc(
      'fetch_plant_details_with_selection_json',
      params: {
        '_user_id': userId,
        '_cw': calendarWeek,
        '_yr': calendarYear,
        '_preset': plantPreset,
      },
    );

    if (data is List<dynamic> && data.isNotEmpty) {
      for (final row in data) {
        FFAppState().locplantselectionlist.add(
              LocPlantSelectionListSchemaStruct(
                idLoc: row['id_loc'] as int? ?? 0,
                plantname: row['plantname'] as String? ?? '',
                climatecondition: row['climatecond'] as String? ?? '',
                agrimethod: row['agrimethod'] as String? ?? '',
                origincountry: row['origincountry'] as String? ?? '',
                usercountry: row['usercountry'] as String? ?? '',
                color: row['color'] as String? ?? '',
                presetBool: row['preset_bool'] as bool? ?? false,
                selected: row['selected'] as bool? ?? false,
                portionsum: (row['portionsum'] as num?)?.toDouble() ?? 0.0,
                portionsize:
                    (row['portionsize'] as num?)?.toDouble() ?? 0.0, // ← new
              ),
            );
      }
      print(
          "locplantselectionlist => ${FFAppState().locplantselectionlist.length} items loaded.");
    } else {
      print('No data returned or empty => locplantselectionlist stays empty.');
    }
  } catch (error) {
    print('Unexpected error in fetchPlantDetailsWithSelection: $error');
  }
}
