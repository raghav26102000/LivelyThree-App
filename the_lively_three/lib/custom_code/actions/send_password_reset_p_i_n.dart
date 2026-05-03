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

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic> sendPasswordResetPIN(String email) async {
  final supabase = Supabase.instance.client;

  // 1. Basic checks
  if (email.trim().isEmpty) {
    return {"success": false, "error": "Email field cannot be empty."};
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  if (!emailRegex.hasMatch(email)) {
    return {"success": false, "error": "Invalid email format."};
  }

  try {
    print("DEBUG: Calling send_password_reset_pin function...");

    // 2. Call the DB function
    final dbResponse = await supabase.rpc('send_password_reset_pin', params: {
      '_email': email,
    });

    if (dbResponse == null || dbResponse['success'] != true) {
      print("DEBUG: Failed or unexpected response: $dbResponse");
      return {
        "success": false,
        "error": dbResponse?['error'] ?? "Unable to process request."
      };
    }

    final resetPin = dbResponse['pin']; // The pin we generated
    print("DEBUG: Received pin: $resetPin from DB");

    // 3. Send the pin via Resend (or any email API)
    //    We do this even if the user doesn't exist, to keep behavior consistent
    //    (the function always returns some random pin).
    print("DEBUG: Sending email to $email via Resend...");
    final resendResponse = await http.post(
      Uri.parse("https://api.resend.com/emails"),
      headers: {
        "Authorization":
            "Bearer #", // Your Resend API key
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "from": "The Lively Three <team@auth.thelivelythree.earth>",
        "to": [email],
        "subject": "Your Password Reset PIN",
        "html":
            "<p>Your password reset PIN is <strong>$resetPin</strong>. Please enter this code in the app to reset your password.</p>",
      }),
    );

    // 4. Check if email sending succeeded
    if (resendResponse.statusCode != 200 && resendResponse.statusCode != 202) {
      print("DEBUG: Email send failed: ${resendResponse.body}");
      // You might still return success to avoid user enumeration,
      // or handle it differently if you'd prefer to show an error.
      return {"success": true, "message": "PIN sent."};
    }

    print("DEBUG: PIN email sent successfully.");

    return {"success": true, "message": "PIN sent to $email."};
  } catch (e) {
    print("DEBUG: Exception in sendPasswordResetPIN: $e");
    // For a consistent user experience, you might still return success
    // to avoid enumerations, or you can show an error if you prefer.
    return {
      "success": false,
      "error": "System error occurred. Please try again later."
    };
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
