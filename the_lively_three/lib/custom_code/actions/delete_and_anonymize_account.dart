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

/// 1) Calls your anonymize_account RPC
/// 2) Signs out locally (mobile/desktop)
Future<void> deleteAndAnonymizeAccount() async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) {
    print('deleteAndAnonymizeAccount: no authenticated user found.');
    return;
  }

  // 1) scrub PII on the server
  try {
    await supabase.rpc('anonymize_account', params: {'_user_id': user.id});
    print('anonymize_account RPC succeeded');
  } catch (e) {
    print('anonymize_account RPC failed: $e');
  }

  // 2) sign out locally
  try {
    await supabase.auth.signOut();
    print('Local signOut succeeded');
  } catch (e) {
    print('Local signOut failed (ignored): $e');
  }
}
