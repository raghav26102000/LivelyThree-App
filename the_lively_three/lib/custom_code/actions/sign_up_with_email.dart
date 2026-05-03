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

import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic?> signUpWithEmail(
  String email,
  String password,
  String confirmPassword,
) async {
  print("DEBUG: Starting signUpWithEmail function.");

  // Check if the passwords match.
  if (password != confirmPassword) {
    print("DEBUG: Passwords do not match.");
    return {"success": false, "error": "Passwords do not match."};
  }

  try {
    final supabase = Supabase.instance.client;

    print("DEBUG: Calling supabase.auth.signUp with email: $email");
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    print("DEBUG: Received signUp response: $res");

    final userId = res.user?.id;
    if (userId == null || userId.trim().isEmpty) {
      print("DEBUG: No valid user ID returned from signUp.");
      return {
        "success": false,
        "error": "Sign-up failed. No valid user ID returned."
      };
    }
    print("DEBUG: Received user ID: $userId");

    // Generate a 6-digit PIN code inline.
    final random = Random();
    final pinCode = (random.nextInt(900000) + 100000).toString();
    print("DEBUG: Generated PIN code: $pinCode");

    // Store the PIN code in the email_verification_tokens table.
    final insertResponse =
        await supabase.from('email_verification_tokens').insert({
      'user_id': userId,
      'token': pinCode,
      'expires_at': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    }).select();
    print("DEBUG: Token insert response: $insertResponse");

    if ((insertResponse as List).isEmpty) {
      print("DEBUG: PIN code insert returned an empty list.");
      return {
        "success": false,
        "error": "Failed to generate a verification PIN."
      };
    }

    print("DEBUG: signUpWithEmail completed successfully, userId: $userId");
    return {"success": true, "userId": userId, "pinCode": pinCode};
  } catch (e) {
    print("DEBUG: Exception in signUpWithEmail: $e");
    return {"success": false, "error": e.toString()};
  }
}
