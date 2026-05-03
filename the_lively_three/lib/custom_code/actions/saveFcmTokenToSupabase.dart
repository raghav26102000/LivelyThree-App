import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _detectPlatform() {
  if (kIsWeb) return 'web';
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  if (Platform.isMacOS) return 'macos';
  if (Platform.isWindows) return 'windows';
  if (Platform.isLinux) return 'linux';
  return 'unknown';
}

Future<void> saveFcmTokenToSupabaseOnce() async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) return;

  try {
    await Firebase.initializeApp();
  } catch (_) {}

  final token = await FirebaseMessaging.instance.getToken();
  if (token == null || token.isEmpty) return;

  final platform = _detectPlatform();
  final options = Firebase.app().options;

  final projectId = options.projectId; // e.g. "thelivelythree-f6fa2"
  final senderId = options.messagingSenderId; // e.g. "108684704876"

  print('Fcm token = $token');
  print('Project id = $projectId');
  print('senderId = $senderId');
  // Check if token already exists for this user
  final existing = await supabase
      .from('user_devices')
      .select('id, fcm_token')
      .eq('user_id', user.id)
      .eq('platform', platform)
      .maybeSingle();

  if (existing != null) {
    // If token is different → update it
    if (existing['fcm_token'] != token) {
      await supabase.from('user_devices').update({
        'fcm_token': token,
        'last_seen': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', existing['id']);
    } else {
      // Just update last_seen
      await supabase.from('user_devices').update({
        'last_seen': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', existing['id']);
    }
  } else {
    // No record yet → insert new one
    await supabase.from('user_devices').insert({
      'user_id': user.id,
      'fcm_token': token,
      'platform': platform,
      'project_id': projectId,
      'sender_id' : senderId,
      'last_seen': DateTime.now().toUtc().toIso8601String(),
    });
    print('Successfully inserted.');
  }
}
