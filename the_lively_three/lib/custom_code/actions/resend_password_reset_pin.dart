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
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> resendPasswordResetPin(String email) async {
  final supabase = Supabase.instance.client;

  try {
    // 1. Check cooldown (5 min between sends)
    final recentToken = await supabase
        .from('password_reset_tokens')
        .select('created_at')
        .eq('email', email)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (recentToken != null && recentToken['created_at'] != null) {
      final createdAt = DateTime.parse(recentToken['created_at']);
      final difference = DateTime.now().difference(createdAt);
      if (difference.inMinutes < 5) {
        return {
          "success": false,
          "error": "Please wait five minutes before requesting another code."
        };
      }
    }

    // 2. Delete existing tokens
    await supabase.from('password_reset_tokens').delete().eq('email', email);

    // 3. Generate new 6-digit PIN
    final newPin = (Random().nextInt(900000) + 100000).toString();

    // 4. Insert new token
    final insertResponse = await supabase.from('password_reset_tokens').insert({
      'email': email,
      'token': newPin,
      'expires_at': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    }).select();

    if (insertResponse == null || (insertResponse as List).isEmpty) {
      return {
        "success": false,
        "error": "Failed to store the verification code. Please try again."
      };
    }

    // 5. Send Verification Email via Resend API
    final resendResponse = await http.post(
      Uri.parse("https://api.resend.com/emails"),
      headers: {
        "Authorization":
            "Bearer #", // <-- Replace with your Resend API key
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "from":
            "The Lively Three <team@auth.thelivelythree.earth>", // <-- Use your verified sender email
        "to": [email],
        "subject": "Your password reset PIN",
        "html":
            "<p>Your password reset PIN is <strong>$newPin</strong>. Please enter this code in the app to reset your password.</p>"
      }),
    );

    if (resendResponse.statusCode != 200 && resendResponse.statusCode != 202) {
      return {
        "success": false,
        "error":
            "Failed to send password reset email. Please check your email or try again."
      };
    }

    return {
      "success": true,
      "message": "Password reset email resent successfully."
    };
  } catch (e) {
    return {"success": false, "error": "System error. Please try again later."};
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
