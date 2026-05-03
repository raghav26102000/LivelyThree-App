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
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

Future<dynamic> resendVerificationEmail(String email) async {
  final supabase = Supabase.instance.client;

  print('DEBUG: Attempting to resend code for $email');

  //--------------------------------------------------------------------
  // 1.  Call the SEC‑DEF function (it enforces 5‑min cool‑down + insert)
  //--------------------------------------------------------------------
  late final String pin; // will hold the new PIN on success
  try {
    final dbResp = await supabase.rpc(
      'resend_verification_token',
      params: {'_email': email},
    );

    print('DEBUG: DB response => $dbResp');

    if (dbResp == null || dbResp['success'] != true) {
      return {
        'success': false,
        'error': dbResp?['error'] ?? 'Database error – please retry.',
      };
    }

    pin = dbResp['pin'];
  } catch (e) {
    print('DEBUG: Exception while talking to DB: $e');
    return {
      'success': false,
      'error': 'System error. Please try again later.',
    };
  }

  //--------------------------------------------------------------------
  // 2.  Send the e‑mail with Resend
  //--------------------------------------------------------------------
  print('DEBUG: Sending PIN $pin to $email via Resend…');
  final httpResp = await http.post(
    Uri.parse('https://api.resend.com/emails'),
    headers: {
      'Authorization':
          'Bearer #', // <-- replace
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'from': 'The Lively Three <team@auth.thelivelythree.earth>',
      'to': [email],
      'subject': 'Your verification PIN',
      'html': '<p>Your verification PIN is <strong>$pin</strong>. '
          'Please enter this code in the app.</p>',
    }),
  );

  print(
    'DEBUG: Resend status ${httpResp.statusCode} – body ${httpResp.body}',
  );

  if (httpResp.statusCode != 200 && httpResp.statusCode != 202) {
    return {
      'success': false,
      'error':
          'Failed to send verification e‑mail. Please check your address or retry.',
    };
  }

  //--------------------------------------------------------------------
  // 3.  All good
  //--------------------------------------------------------------------
  return {
    'success': true,
    'message': 'Verification e‑mail resent successfully.',
  };
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
