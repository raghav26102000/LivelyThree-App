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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

Future<dynamic> sendVerificationEmail(
  String email,
  String signupPassword,
  String signupPasswordConfirm,
) async {
  print("DEBUG: Starting sendVerificationEmail for email: $email");

  // 1. Check if passwords match
  if (signupPassword != signupPasswordConfirm) {
    print("DEBUG: Password mismatch detected.");
    return {
      "success": false,
      "error": "Passwords do not match. Please try again."
    };
  }

  final supabase = Supabase.instance.client;

  // 2. Generate a 6-digit numeric PIN
  print("DEBUG: Generating random 6-digit PIN...");
  final rand = Random();
  final pinCode = List.generate(6, (_) => rand.nextInt(10)).join();
  print("DEBUG: PIN generated: $pinCode");

  // 3. Insert the new PIN via a SECURITY DEFINER function
  try {
    final expiresAt =
        DateTime.now().add(const Duration(hours: 24)).toIso8601String();
    print(
        "DEBUG: Calling insert_verification_token with expiresAt: $expiresAt");

    final dbResponse = await supabase.rpc('insert_verification_token', params: {
      '_email': email,
      '_pin_code': pinCode,
      '_expires_at': expiresAt,
    });

    print("DEBUG: insert_verification_token response: $dbResponse");

    if (dbResponse == null || dbResponse['success'] != true) {
      print("DEBUG: Failed to insert token in DB.");
      return {
        "success": false,
        "error": dbResponse?['error'] ?? "Failed to generate verification code."
      };
    }
  } catch (e) {
    print("DEBUG: Exception during DB insert: $e");
    return {
      "success": false,
      "error": "Database error. Please try again later."
    };
  }

  // 4. Send the generated PIN to the user via your email service
  print("DEBUG: Sending email to $email via Resend...");
  final response = await http.post(
    Uri.parse("https://api.resend.com/emails"),
    headers: {
      "Authorization":
          "Bearer #", // your actual Resend API key
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "from": "The Lively Three <team@auth.thelivelythree.earth>",
      "to": [email],
      "subject": "Your Verification PIN",
      "html":
          "<p>Your verification PIN is: <strong>$pinCode</strong></p><p>Please enter this PIN in the app to complete your signup.</p>",
    }),
  );

  print("DEBUG: Resend API response status: ${response.statusCode}");
  print("DEBUG: Resend API response body: ${response.body}");

  if (response.statusCode != 200 && response.statusCode != 202) {
    print("DEBUG: Failed to send email.");
    return {
      "success": false,
      "error": "Failed to send verification email. Please try again later."
    };
  }

  // 5. Return success
  print("DEBUG: Successfully sent verification email and stored PIN.");
  return {"success": true, "pinCode": pinCode};
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
