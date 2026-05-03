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

Future<List<int>?> countUserInteractions(String user) async {
  final supabaseClient = Supabase.instance.client;

  try {
    // Call the Supabase RPC function
    final data = await supabaseClient.rpc(
      'count_user_interactions',
      params: {
        'p_user_id': user, // p_user_id should be a valid UUID string
      },
    );

    print(data);

    // Ensure the data is valid and not empty
    if (data is List<dynamic> && data.isNotEmpty) {
      final result = data.first as Map<String, dynamic>;
      int userCount = (result['user_count'] as num).toInt();
      int totalCount = (result['total_count'] as num).toInt();
      print('RPC result -> userCount: $userCount, totalCount: $totalCount');
      return [userCount, totalCount];
    } else {
      print('No data returned from Supabase for countUserInteractionsRPC.');
      return null;
    }
  } catch (error) {
    print('Unexpected error in countUserInteractionsRPC: $error');
    return null;
  }
}
