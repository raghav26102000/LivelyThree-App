import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserActionAuditService {
  final SupabaseClient _client;

  UserActionAuditService(this._client);

  /// Logs user action into the user_action_audit table
  Future<void> logUserAction({
    required String userId,
    required String action,
    required String screenName,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final response = await _client.from('user_action_audit').insert({
        'user_id': userId,
        'action': action,
        'screen_name': screenName,
        'user_data': userData != null ? jsonEncode(userData) : null,
      });

      print("✅ User action logged: $action on $screenName");
    } catch (e) {
      print("❌ Failed to log user action: $e");
      throw e;
    }
  }
}
