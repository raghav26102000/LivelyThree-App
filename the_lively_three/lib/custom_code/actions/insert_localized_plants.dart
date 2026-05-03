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

Future<bool> insertLocalizedPlants(
  List<int> blueprintIndexList,
  List<int> originCountryIndexList,
  List<int> agroMethodIndexList,
  List<int> climateConditionIndexList,
  List<int> userRegionIndexList,
) async {
  final supabaseClient = Supabase.instance.client;

  try {
    for (final blueprintIndex in blueprintIndexList) {
      for (final countryIndex in originCountryIndexList) {
        for (final agroIndex in agroMethodIndexList) {
          for (final climateIndex in climateConditionIndexList) {
            for (final userIndex in userRegionIndexList) {
              // print('Checking combination: blueprint=$blueprintIndex, origin=$countryIndex, agro=$agroIndex, climate=$climateIndex, user=$userIndex');

              try {
                final existingEntry = await supabaseClient
                    .from('localizedfooditem')
                    .select()
                    .eq('id_blueprint', blueprintIndex)
                    .eq('id_origin', countryIndex)
                    .eq('id_agro', agroIndex)
                    .eq('id_climate', climateIndex)
                    .eq('id_userregion', userIndex)
                    .maybeSingle();

                //       print('Query result for this combination: $existingEntry');

                if (existingEntry == null) {
                  // Insert and request the inserted rows
                  try {
                    final inserted =
                        await supabaseClient.from('localizedfooditem').insert({
                      'id_blueprint': blueprintIndex,
                      'id_origin': countryIndex,
                      'id_agro': agroIndex,
                      'id_climate': climateIndex,
                      'id_userregion': userIndex,
                    }).select(); // Request the inserted row back

                    // If insertion was successful, `inserted` should contain the new row
                    print('Inserted new row(s): $inserted');
                  } catch (insertError) {
                    print('Error inserting row: $insertError');
                    return false;
                  }
                } else {
                  print(
                      'Entry already exists for this combination, skipping insertion.');
                }
              } catch (queryError) {
                print('Error querying existing entry: $queryError');
                return false;
              }
            }
          }
        }
      }
    }

    return true; // Completed all insertions successfully
  } catch (error) {
    print('Unexpected error in the overall function: $error');
    return false;
  }
}
