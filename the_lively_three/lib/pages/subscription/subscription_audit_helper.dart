// lib/pages/subscription/subscription_audit_helper.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_lively_three/utils/user_action_audit_service.dart';
import 'subscription_upgrade_actions.dart';

// These are created ONCE when this file is loaded – not on every call.
final SupabaseClient _supabase = Supabase.instance.client;
final UserActionAuditService _auditService =
    UserActionAuditService(_supabase);

// Single source of truth for this screen name
const String subscriptionScreenName = 'subscription_upgrade';

/// Call this from UpgradeSubscriptionPage to log audit events.
/// userId is always taken from Supabase.auth.currentUser.
Future<void> subscriptionAuditLog({
  required String action,
  Map<String, dynamic>? extra,
}) async {
  try {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null || userId.isEmpty) {
      debugPrint(
        '[audit][$subscriptionScreenName][$action] skipped: no userId',
      );
      return;
    }

    await _auditService.logUserAction(
      userId: userId,
      action: action,
      screenName: subscriptionScreenName,
      userData: extra,
    );
  } catch (e, st) {
    debugPrint(
      '[audit][$subscriptionScreenName][$action] FAILED: $e',
    );
    debugPrint(st.toString());
  }
}
