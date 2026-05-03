import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';

class OAuthResult {
  final bool success;
  final Object? error;
  final String? message;
  final bool userExists; // Added field

  OAuthResult({
    required this.success,
    this.error,
    this.message,
    this.userExists = false, // Default value
  });
}

Future<OAuthResult> signUpWithGoogle() async {
  try {
    debugPrint("🟢 Google button pressed");

    // Initialize Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
        'openid',
      ],
      // Replace with your actual Web Client ID from Google Cloud Console
      serverClientId:
          '675490404684-bckq46h05vs5j6q6v425jtbedkqtc5hc.apps.googleusercontent.com',
    );

    debugPrint("🔑 Starting native Google Sign-In...");

    // Sign out first to force account selection
    await googleSignIn.signOut();

    // Trigger the native Google Sign-In flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      debugPrint("❌ User cancelled Google Sign-In");
      return OAuthResult(
        success: false,
        message: 'Sign-in cancelled by user',
      );
    }

    debugPrint("✅ Google user selected: ${googleUser.email}");
    debugPrint("🔐 Getting authentication tokens...");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final String? idToken = googleAuth.idToken;
    final String? accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw Exception('No ID Token found from Google Sign-In');
    }

    debugPrint("✅ Got ID token, signing in to Supabase...");

    // Sign in to Supabase using the Google tokens
    final AuthResponse response =
        await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (response.user == null) {
      throw Exception('Supabase sign-in failed: No user returned');
    }

    debugPrint("✅✅ Successfully signed in!");
    debugPrint("   User: ${response.user!.email}");
    debugPrint("   ID: ${response.user!.id}");

    return OAuthResult(
      success: true,
      message: 'Signed in as ${response.user!.email}',
    );
  } on Exception catch (e, st) {
    debugPrint("❌ Google login failed (Exception): $e");
    debugPrint("Stack trace: $st");
    return OAuthResult(
      success: false,
      error: e,
      message: e.toString(),
    );
  } catch (e, st) {
    debugPrint("❌ Google login failed (Error): $e");
    debugPrint("Stack trace: $st");
    return OAuthResult(
      success: false,
      error: e,
      message: e.toString(),
    );
  }
}

Future<OAuthResult> signInWithGoogle() async {
  try {
    print("🟢 Google Sign-In initiated");

    // ⛔ Prevent Supabase auth listener from routing automatically
    suppressAuthNavigation = true;

    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile', 'openid'],
      serverClientId:
          '675490404684-bckq46h05vs5j6q6v425jtbedkqtc5hc.apps.googleusercontent.com',
    );

    await googleSignIn.signOut(); // fresh login
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      print("❌ Google sign-in cancelled");

      suppressAuthNavigation = false;
      return OAuthResult(
        success: false,
        userExists: false,
        message: "Sign-in cancelled",
      );
    }

    final email = googleUser.email.toLowerCase().trim();
    print("📧 Google email: $email");

    // ---- SUPABASE LOGIN FIRST (required for RLS) ----
    final googleAuth = await googleUser.authentication;

    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      suppressAuthNavigation = false;
      throw Exception("Missing ID Token");
    }

    print("🔐 Signing in with Supabase using Google tokens...");

    final supaRes = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (supaRes.user == null) {
      print("❌ Supabase login failed");
      suppressAuthNavigation = false;
      return OAuthResult(
        success: false,
        userExists: false,
        message: "Could not authenticate",
      );
    }

    print("✅ Supabase Auth Success → ${supaRes.user!.email}");

    // ---- CHECK IF USER EXISTS IN CUSTOM TABLE ----
    print("🔍 Checking custom table (public.users)…");

    final existingUser = await Supabase.instance.client
        .from("users")
        .select("id, email")
        .eq("email", email)
        .eq("is_onboarded", false)
        .maybeSingle();

    if (existingUser == null) {
      print("❌ User NOT found in custom table → FORCE LOGOUT");

      // Remove session — critical!!
      await Supabase.instance.client.auth.signOut();
      await googleSignIn.signOut();

      suppressAuthNavigation = false;

      return OAuthResult(
        success: false,
        userExists: false,
        message: "No account found. Please sign up first.",
      );
    }

    print("✅ User found in custom table → Login Allowed");

    suppressAuthNavigation = false;

    return OAuthResult(
      success: true,
      userExists: true,
      message: "Login success",
    );
  } catch (e, st) {
    print("❌ Google Sign-In failed: $e\n$st");

    suppressAuthNavigation = false;

    return OAuthResult(
      success: false,
      userExists: false,
      message: e.toString(),
      error: e,
    );
  }
}
