import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OAuthResult {
  final bool success;
  final Object? error;
  OAuthResult({required this.success, this.error});
}

Future<OAuthResult> signInWithApple() async {
  try {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: kIsWeb ? null : 'com.your.app://login-callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
    return OAuthResult(success: true);
  } catch (e) {
    return OAuthResult(success: false, error: e);
  }
}
