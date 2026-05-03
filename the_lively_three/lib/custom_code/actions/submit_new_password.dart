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

Future<dynamic> submitNewPassword(
  String email,
  String newPassword,
  String confirmPassword,
) async {
  final supabase = Supabase.instance.client;

  // 1) Ensure passwords match
  if (newPassword != confirmPassword) {
    return {"success": false, "error": "Passwords do not match."};
  }

  try {
    // 2) Call the function
    final response = await supabase.rpc('reset_user_password', params: {
      'user_email': email,
      'new_password': newPassword,
    });

    // 3) Check result
    if (response != null && response['success'] == true) {
      return {"success": true, "message": response['message']};
    } else {
      return {
        "success": false,
        "error": response?['error'] ?? "Password reset failed."
      };
    }
  } catch (e) {
    return {
      "success": false,
      "error": "System error occurred: ${e.toString()}"
    };
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
