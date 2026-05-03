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

Future<String?> updateDataContractConsent(
    String userId, int contractId, bool consentStatus) async {
  final supabaseClient = Supabase.instance.client;
  final currentTime = DateTime.now().toUtc().toIso8601String();

  try {
    // Step 1: Retrieve the contract name.
    final contractResponse = await supabaseClient
        .from('datacontract')
        .select('contract_name')
        .eq('id', contractId)
        .maybeSingle();

    if (contractResponse == null || contractResponse['contract_name'] == null) {
      print('Error: Contract not found.');
      return null;
    }
    final contractName = contractResponse['contract_name'] as String;

    // Step 2: Retrieve frequency for individual indicators (is_community = false)
    String? frequency;
    final freqResponse = await supabaseClient
        .from('datacontractindicators')
        .select('userindicators(frequency, is_community)')
        .eq('id_datacontract', contractId)
        .limit(1) // Fix: Only retrieve one row to avoid multiple rows error
        .maybeSingle();

    if (freqResponse != null && freqResponse['userindicators'] != null) {
      final userIndicator = freqResponse['userindicators'];
      if (userIndicator['is_community'] == false) {
        frequency = userIndicator['frequency'] as String;
      }
    }
    frequency ??= 'weekly';

    // Step 3: Retrieve the user-contract relationship row.
    final existingResponse = await supabaseClient
        .from('usercontracts')
        .select('id, current_consent')
        .eq('id_datacontract', contractId)
        .eq('id_user', userId)
        .maybeSingle();

    if (existingResponse == null) {
      print('Error: User-contract relationship not initialized.');
      return null;
    }

    if (consentStatus == true) {
      // Consent granted: update immediately
      await supabaseClient
          .from('usercontracts')
          .update({
            'current_consent': true,
            'withdrawal_effective_date': null, // Clear any pending withdrawal
            'updated_at': currentTime,
          })
          .eq('id', existingResponse['id'])
          .select();

      await supabaseClient.from('datacontractconsentlog').insert({
        'id_datacontract': contractId,
        'id_user': userId,
        'change_consent': true,
        'change_time': currentTime,
      }).select();

      print('Consent granted immediately for contract $contractName.');
      return contractName;
    } else {
      // Consent withdrawal: calculate the effective withdrawal date
      DateTime effectiveDate;
      if (frequency == '4weekly') {
        effectiveDate = _calculateNext4WeeklyStart(DateTime.now());
      } else {
        effectiveDate = _calculateNextMonday(DateTime.now());
      }

      // Update the usercontracts record with the pending withdrawal effective date
      await supabaseClient
          .from('usercontracts')
          .update({
            'withdrawal_effective_date':
                effectiveDate.toUtc().toIso8601String(),
            'updated_at': currentTime,
          })
          .eq('id', existingResponse['id'])
          .select();

      // Log the user's action immediately, but actual consent remains TRUE until effective date
      await supabaseClient.from('datacontractconsentlog').insert({
        'id_datacontract': contractId,
        'id_user': userId,
        'change_consent': false,
        'change_time': currentTime,
      }).select();

      print(
          'Consent withdrawal for contract $contractName will take effect on $effectiveDate.');
      return effectiveDate.toIso8601String();
    }
  } catch (error) {
    print('Unexpected error during consent update: $error');
    return null;
  }
}

/// Helper: Calculate next Monday at 00:00 (for weekly indicators)
DateTime _calculateNextMonday(DateTime now) {
  int daysToAdd = ((8 - now.weekday) % 7);
  if (daysToAdd == 0) daysToAdd = 7;
  DateTime nextMonday =
      DateTime(now.year, now.month, now.day).add(Duration(days: daysToAdd));
  return DateTime(nextMonday.year, nextMonday.month, nextMonday.day);
}

/// Helper: Calculate the start of the next 4-week block (for 4weekly indicators)
DateTime _calculateNext4WeeklyStart(DateTime now) {
  int currentWeek = int.parse(DateFormat("w").format(now));
  int currentBlock = ((currentWeek - 1) / 4).floor();
  int nextBlockStartWeek = currentBlock * 4 + 1;
  if (nextBlockStartWeek <= currentWeek) {
    nextBlockStartWeek += 4;
  }
  DateTime firstDayOfYear = DateTime(now.year, 1, 1);
  int offset = firstDayOfYear.weekday - 1;
  DateTime firstMonday = firstDayOfYear.subtract(Duration(days: offset));
  DateTime blockStart =
      firstMonday.add(Duration(days: (nextBlockStartWeek - 1) * 7));
  return DateTime(blockStart.year, blockStart.month, blockStart.day);
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
