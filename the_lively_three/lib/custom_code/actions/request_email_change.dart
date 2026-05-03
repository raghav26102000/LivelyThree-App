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
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> requestEmailChange(
    String userId, String oldEmail, String newEmail) async {
  final supabase = Supabase.instance.client;
  final uuid = Uuid(); // Initialize UUID generator

  try {
    print("DEBUG: Starting email change request");
    print("DEBUG: userId: $userId, oldEmail: $oldEmail, newEmail: $newEmail");

    // **1. Prevent changing to the same email**
    if (oldEmail.trim().toLowerCase() == newEmail.trim().toLowerCase()) {
      print("DEBUG: Old and new emails are identical. Aborting request.");
      return {
        "success": false,
        "error": "The new email cannot be the same as the old email."
      };
    }

    // **2. Validate user exists and owns the old email**
    final userCheck = await supabase
        .from('users')
        .select('id')
        .eq('id', userId)
        .eq('email', oldEmail)
        .maybeSingle();

    print("DEBUG: User check response: $userCheck");

    if (userCheck == null) {
      print("DEBUG: No matching user found.");
      return {
        "success": false,
        "error": "User not found or email does not match."
      };
    }

    // **3. Prevent frequent requests (cooldown: 5 min)**
    final recentRequest = await supabase
        .from('email_change_tokens')
        .select('created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    print("DEBUG: Recent request response: $recentRequest");

    if (recentRequest != null && recentRequest['created_at'] != null) {
      final createdAt = DateTime.parse(recentRequest['created_at']);
      if (DateTime.now().difference(createdAt).inMinutes < 5) {
        print("DEBUG: Cooldown active. Wait before requesting again.");
        return {
          "success": false,
          "error":
              "Please wait 5 minutes before requesting another email change."
        };
      }
    }

    // **4. Delete expired tokens for user**
    await supabase.from('email_change_tokens').delete().eq('user_id', userId);

    // **5. Generate a new 6-digit PIN & UUID**
    final newPin = (Random().nextInt(900000) + 100000).toString();
    final newTokenId = uuid.v4(); // Generate a new UUID for 'id'

    print("DEBUG: Generated PIN: $newPin, Generated UUID: $newTokenId");

    // **6. Insert new token into `email_change_tokens`**
    final insertResponse = await supabase.from('email_change_tokens').insert({
      'id': newTokenId,
      'user_id': userId,
      'old_email': oldEmail,
      'new_email': newEmail,
      'token': newPin,
      'expires_at': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    }).select();

    print("DEBUG: Insert response: $insertResponse");

    if (insertResponse == null || (insertResponse as List).isEmpty) {
      print("DEBUG: Failed to insert verification token.");
      return {
        "success": false,
        "error": "Failed to create verification token. Please try again."
      };
    }

    // **7. Send Verification Email using Resend API**
    final emailResponse = await http.post(
      Uri.parse("https://api.resend.com/emails"),
      headers: {
        "Authorization": "Bearer #",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "from": "The Lively Three <team@auth.thelivelythree.earth>",
        "to": [newEmail],
        "subject": "Confirm Your Email Change Request",
        "html":
            "<p>Your email change verification PIN is <strong>$newPin</strong>. "
                "Enter this code in the app to confirm your email update.</p>",
      }),
    );

    print("DEBUG: Email response status: ${emailResponse.statusCode}");

    if (emailResponse.statusCode != 200 && emailResponse.statusCode != 202) {
      print("DEBUG: Email sending failed. Status: ${emailResponse.statusCode}");
      return {
        "success": false,
        "error": "Failed to send verification email. Please try again."
      };
    }

    print("DEBUG: Email change PIN sent successfully.");
    return {
      "success": true,
      "message": "Verification email sent successfully."
    };
  } catch (e) {
    print("DEBUG: Exception in requestEmailChange: $e");
    return {"success": false, "error": "System error. Please try again later."};
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
