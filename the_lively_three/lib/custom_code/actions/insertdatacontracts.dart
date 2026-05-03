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

Future<String?> insertdatacontracts(
  List<int> individualIndicatorIndexList,
  List<int> sharedIndicatorIndexList,
  String contractName,
  String description,
  String validityType,
  String contractStatus,
  String contractType,
  int? contractId,
) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Check if either list is empty
    if (individualIndicatorIndexList.isEmpty &&
        sharedIndicatorIndexList.isEmpty) {
      print('Error: Both indicator lists are empty.');
      return 'error_empty_list';
    }

    // Step 1: Check if contractId is provided (for updating an existing contract)
    if (contractId != null) {
      // Update the existing contract
      final updateResponse = await supabaseClient
          .from('datacontract')
          .update({
            'contract_name': contractName,
            'description': description,
            'validity_type': validityType,
            'contract_type': contractType,
            'status': contractStatus,
          })
          .eq('id', contractId)
          .maybeSingle();

      if (updateResponse == null) {
        print('Error: Contract update failed.');
        return 'error_contract_update';
      }

      // Delete existing indicators linked to the contract
      final deleteResponse = await supabaseClient
          .from('datacontractindicators')
          .delete()
          .eq('id_datacontract', contractId);

      if (deleteResponse == null) {
        print('Error: Failed to delete related indicators.');
        return 'error_delete_indicators';
      }
    } else {
      // Step 2: Insert a new contract if contractId is not provided
      final insertResponse = await supabaseClient
          .from('datacontract')
          .insert({
            'contract_name': contractName,
            'description': description,
            'validity_type': validityType,
            'contract_type': contractType,
            'status': contractStatus,
          })
          .select('id')
          .maybeSingle();

      if (insertResponse == null || insertResponse['id'] == null) {
        print('Error: Contract creation failed.');
        return 'error_contract_creation';
      }

      contractId = insertResponse['id'] as int;
    }

    // Step 3: Insert individual indicators for the contract with "received" type
    if (contractId != null && individualIndicatorIndexList.isNotEmpty) {
      List<Map<String, dynamic>> individualIndicatorRows =
          individualIndicatorIndexList.map((indicatorId) {
        return {
          'id_datacontract': contractId,
          'id_indicator': indicatorId,
          'shared_received': 'shared', // Set as "received"
        };
      }).toList();

      // Insert individual indicators into the table
      final insertIndividualIndicatorsResponse = await supabaseClient
          .from('datacontractindicators')
          .insert(individualIndicatorRows)
          .select();

      if (insertIndividualIndicatorsResponse.isEmpty) {
        print('Error: Failed to insert individual indicators.');
        return 'error_ind_indicator_insert';
      }
    }

    // Step 4: Insert shared indicators for the contract with "shared" type
    if (contractId != null && sharedIndicatorIndexList.isNotEmpty) {
      List<Map<String, dynamic>> sharedIndicatorRows =
          sharedIndicatorIndexList.map((indicatorId) {
        return {
          'id_datacontract': contractId,
          'id_indicator': indicatorId,
          'shared_received': 'received', // Set as "shared"
        };
      }).toList();

      final insertSharedIndicatorsResponse = await supabaseClient
          .from('datacontractindicators')
          .insert(sharedIndicatorRows)
          .select();

      if (insertSharedIndicatorsResponse.isEmpty) {
        print('Error: Failed to insert shared indicators.');
        return 'error_shared_indicator_insert';
      }
    }
  } catch (error) {
    print('Unexpected error: $error');
    return 'error';
  }

  return contractName;
}
