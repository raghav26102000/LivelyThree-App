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

Future<bool> initializeUserContractandLog(String userId, int contractId) async {
  final supabaseClient = Supabase.instance.client;
  final currentTime = DateTime.now().toUtc().toIso8601String();

  try {
    print(
        'Checking for existing user-contract entry for userId: $userId, contractId: $contractId');

    // Retrieve current consent and any pending withdrawal effective date
    final existingResponse = await supabaseClient
        .from('usercontracts')
        .select('current_consent, withdrawal_effective_date')
        .eq('id_datacontract', contractId)
        .eq('id_user', userId)
        .maybeSingle();

    if (existingResponse != null &&
        existingResponse['current_consent'] != null) {
      final currentConsent = existingResponse['current_consent'] as bool;
      final withdrawalEffectiveDateStr =
          existingResponse['withdrawal_effective_date'] as String?;

      // If there's a pending withdrawal effective date, determine if it should be in effect
      if (withdrawalEffectiveDateStr != null) {
        final withdrawalEffectiveDate =
            DateTime.parse(withdrawalEffectiveDateStr);
        if (DateTime.now().isBefore(withdrawalEffectiveDate)) {
          // The withdrawal is pending and will take effect later.
          print(
              'Entry exists. Pending withdrawal effective on: $withdrawalEffectiveDate');
          return false; // UI should show consent as withdrawn.
        } else {
          // The effective date has passed—assume the consent should now be false.
          print('Withdrawal effective date has passed. Returning false.');
          return false;
        }
      } else {
        print('Entry exists. Consent status: $currentConsent');
        return currentConsent;
      }
    }

    // No existing entry found; insert a new one with default consent (true).
    print(
        'No existing entry found. Inserting new entry with default consent (true)...');
    await supabaseClient.from('usercontracts').insert({
      'id_datacontract': contractId,
      'id_user': userId,
      'current_consent': true,
      'updated_at': currentTime,
    }).select();

    print('Logging default consent in datacontractconsentlog...');
    await supabaseClient.from('datacontractconsentlog').insert({
      'id_datacontract': contractId,
      'id_user': userId,
      'change_consent': true,
      'change_time': currentTime,
    }).select();

    print('Initialization complete: Default consent set to true.');
    return true;
  } catch (error) {
    print('Unexpected error during initialization: $error');
    rethrow;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
