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

Future<dynamic> customSignIn(String email, String password) async {
  final supabase = Supabase.instance.client;
  try {
    print("DEBUG: Starting customSignIn for email: $email");

    // Use the current signInWithPassword method.
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    print("DEBUG: Sign-in attempt complete. Checking user response...");

    final user = res.user;
    if (user == null) {
      print("DEBUG: Sign in failed. No user returned.");
      return {"success": false, "error": "Sign in failed: No user returned."};
    }

    print("DEBUG: User signed in successfully. User ID: ${user.id}");

    // Query the "users" table to check the email_verified flag.
    final userResponse = await supabase
        .from('users')
        .select('email_verified')
        .eq('id', user.id)
        .maybeSingle();

    print("DEBUG: User record fetched from 'users' table: $userResponse");

    if (userResponse == null) {
      print("DEBUG: No matching record found in 'users' table.");
      return {"success": false, "error": "User record not found."};
    }

    // Expect userResponse to be a Map<String, dynamic>.
    final userRecord = userResponse as Map<String, dynamic>;
    final emailVerified = userRecord['email_verified'] as bool?;

    print("DEBUG: Retrieved email_verified flag: $emailVerified");

    if (emailVerified != true) {
      print("DEBUG: Email not verified. Blocking sign-in.");
      return {
        "success": false,
        "error": "Email not verified. Please verify your email first."
      };
    }

    print("DEBUG: Sign-in successful. Email is verified.");
    return {"success": true, "user": user};
  } catch (e) {
    String errorMessage;
    if (e is AuthException) {
      errorMessage = e.message;
    } else if (e is PostgrestException) {
      errorMessage = e.message;
    } else {
      errorMessage = e.toString();
    }

    print("DEBUG: Exception caught in customSignIn: $errorMessage");

    return {"success": false, "error": errorMessage};
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
