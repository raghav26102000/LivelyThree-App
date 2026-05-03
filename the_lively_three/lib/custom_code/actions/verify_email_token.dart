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

Future<dynamic?> verifyEmailToken(String token) async {
  print("DEBUG: Verifying token: $token");
  final supabase = Supabase.instance.client;

  // Look up the token record in email_verification_tokens.
  // maybeSingle() returns null if no row is found.
  final response = await supabase
      .from('email_verification_tokens')
      .select()
      .eq('token', token)
      .maybeSingle();

  if (response == null) {
    print("DEBUG: Token not found or expired.");
    return {"success": false, "error": "Invalid or expired token."};
  }

  // Assuming the response is a Map.
  final tokenRecord = response as Map<String, dynamic>;
  final userId = tokenRecord['user_id'];
  if (userId == null) {
    print("DEBUG: Token record missing user_id.");
    return {"success": false, "error": "Invalid token data."};
  }
  print("DEBUG: Token found for userId: $userId");

  // Update the user's record in public.users to mark the email as verified.
  // We expect this call to return a list of updated rows.
  final updateResponse = await supabase
      .from('users')
      .update({
        'verified_email': true,
      })
      .eq('id', userId)
      .select();

  if (updateResponse == null ||
      (updateResponse is List && updateResponse.isEmpty)) {
    print("DEBUG: Failed to update user verification status.");
    return {"success": false, "error": "Failed to update verification status."};
  }

  // Delete the token record so it cannot be reused.
  final deleteResponse = await supabase
      .from('email_verification_tokens')
      .delete()
      .eq('token', token);
  print("DEBUG: Delete token response: $deleteResponse");

  print("DEBUG: verifyEmailToken completed successfully.");
  return {"success": true};
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
