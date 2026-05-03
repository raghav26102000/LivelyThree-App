// lib/payments/promo_code_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Row model (optional convenience).
class PromoCode {
  final int id;
  final String promocode;
  final String offerId;     // e.g., Play offerId token or your internal id
  final int? platform;    // e.g., 'android', 'ios', 'web'
  final String? influencerId; // uuid
  final num status;          // 1 = active, 0 = inactive (your convention)
  final String createdBy;    // uuid
  final DateTime createdAt;
  final String updatedBy;    // uuid
  final DateTime updatedAt;
  final int originalSubscriptionId;
  final int usedCount; 
  final int restrictedCount;
  final DateTime startFrom; 
  final DateTime endOn;

  PromoCode({
    required this.id,
    required this.promocode,
    required this.offerId,
    required this.platform,
    required this.influencerId,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.originalSubscriptionId,
    required this.usedCount,
    required this.restrictedCount,
    required this.startFrom,
    required this.endOn,
  });

  static PromoCode fromMap(Map<String, dynamic> m) {
    return PromoCode(
      id           : m['id'] as int,
      promocode    : m['promocode'] as String,
      offerId      : m['offer_id'] as String,
      platform     : m['platform'] as int?,
      influencerId : m['influencer_id'] as String?,
      status       : (m['status'] ?? 0) as num,
      createdBy    : m['created_by'] as String,
      createdAt    : DateTime.parse(m['created_at'] as String).toUtc(),
      updatedBy    : m['updated_by'] as String,
      updatedAt    : DateTime.parse(m['updated_at'] as String).toUtc(),
      originalSubscriptionId : (m['original_subscription_id'] ?? 1) as int,
      usedCount    : (m['used_count'] ?? 0) as int,
      restrictedCount : (m['restricted_count'] ?? 1) as int,
      startFrom    : DateTime.parse(m['start_from'] as String).toUtc(),
      endOn        : DateTime.parse(m['end_on'] as String).toUtc(),
    );
  }
}

class PromoCodeService {
  
  static final _client = Supabase.instance.client;

  static String _normalize(String code) => code.trim().toUpperCase();

  // Put these in PromoCodeService (top-level of the class)
  static String? lastError;
  static const String _errInvalid          = 'invalid';
  static const String _errPlatformMismatch = 'platform_mismatch';
  static const String _errProductMismatch  = 'product_mismatch';
  static const String _errAlreadyUsed      = 'already_used';
  static const String _errNotStarted       = 'not_started';
  static const String _errExpired          = 'expired';
  static const String _errUsageLimit       = 'usage_limit_reached';
  static const String _errUnknown          = 'unknown_error';

  static int? lastPromoOriginalSubId;

  static Future<PromoCode?> fetchActive({
    required String code,
    required int platform,
    required int originalSubscriptionId,
  }) async {
    try {
      lastError = null;

      final normalized = _normalize(code);
      //final wantPlatform = platform.trim().toLowerCase();
      final wantPlatform = platform;
      
      debugPrint(
        '[PromoCodeService] fetchActive → code="$normalized", platform="$wantPlatform", original_subscription_id=$originalSubscriptionId',
      );

      // 1) Fetch by code only (to differentiate reasons ourselves)
      final rows = await _client
          .from('promocode')
          .select('*')
          .eq('promocode', normalized)
          .limit(1);

      if (rows is! List || rows.isEmpty) {
        lastError = _errInvalid;
        debugPrint('[PromoCodeService] result=INVALID (code not found)');
        return null;
      }

      final row = (rows.first as Map<String, dynamic>);
      debugPrint('[PromoCodeService] fetched row → $row');

      // 2) Platform match (case-insensitive)
      //final rowPlatform = (row['platform'] as String?)?.trim().toLowerCase() ?? '';
      final rowPlatform = (row['platform'] as int?) ?? 0;
      if (rowPlatform != wantPlatform) {
        lastError = _errPlatformMismatch;
        debugPrint('[PromoCodeService] result=PLATFORM_MISMATCH db="$rowPlatform" want="$wantPlatform"');
        return null;
      }

      // 3) Product match
      final rowSubId = (row['original_subscription_id'] as num?)?.toInt();
      PromoCodeService.lastPromoOriginalSubId = rowSubId;
      if (rowSubId != originalSubscriptionId) {
        lastError = _errProductMismatch;
        debugPrint('[PromoCodeService] result=PRODUCT_MISMATCH db=$rowSubId want=$originalSubscriptionId');
        return null;
      }

      // 4) Status check
      final rowStatus = (row['status'] as num?)?.toInt() ?? 0;
      if (rowStatus == 0) {
        lastError = _errAlreadyUsed;
        debugPrint('[PromoCodeService] result=ALREADY_USED (status=0)');
        return null;
      }

      // 5) Date window check: start_from ≤ now ≤ end_on (timestamps are stored with tz)
      // final now = DateTime.now().toUtc();
      // final startFrom = DateTime.parse(row['start_from'] as String).toUtc();
      // final endOn     = DateTime.parse(row['end_on'] as String).toUtc();

      final now = DateTime.now();
      final startFrom = DateTime.parse(row['start_from'] as String);
      final endOn     = DateTime.parse(row['end_on'] as String);

      debugPrint("[debug] now=$now | startFrom=$startFrom | endOn=$endOn");

      if (now.isBefore(startFrom)) {
        lastError = _errNotStarted;
        debugPrint('[PromoCodeService] result=NOT_STARTED start_from=$startFrom now=$now');
        return null;
      }
      if (now.isAfter(endOn)) {
        lastError = _errExpired;
        debugPrint('[PromoCodeService] result=EXPIRED end_on=$endOn now=$now');
        return null;
      }

      // 6) Usage limit check: used_count < restricted_count
      final usedCount       = (row['used_count'] ?? 0) as int;
      final restrictedCount = (row['restricted_count'] ?? 1) as int;
      if (usedCount >= restrictedCount) {
        lastError = _errUsageLimit;
        debugPrint('[PromoCodeService] result=USAGE_LIMIT reached used=$usedCount of $restrictedCount');
        return null;
      }

      final promo = PromoCode.fromMap(row);
      debugPrint('[PromoCodeService] result=OK id=${row['id']} offerId=${row['offerId'] ?? row['offer_id']}');
      return promo;
    } catch (e) {
      lastError = _errUnknown;
      debugPrint('[PromoCodeService] fetchActive error: $e');
      return null;
    }
  }


  static Future<bool> markPromoUsed({required int id}) async {
  try {
    final u = _client.auth.currentUser;
    if (u == null) {
      debugPrint('[PromoCodeService] setStatus: no logged-in user');
      return false;
    }

    // Step 1: Fetch current used_count and restricted_count
    final row = await _client
        .from('promocode')
        .select('used_count, restricted_count')
        .eq('id', id)
        .maybeSingle();

    if (row == null) {
      debugPrint('[PromoCodeService] setStatus: promo not found (id=$id)');
      return false;
    }

    int usedCount = (row['used_count'] ?? 0) as int;
    final int restrictedCount = (row['restricted_count'] ?? 1) as int;

    // Step 2: Increment used_count
    usedCount += 1;

    // Step 3: If used_count >= restricted_count, set status=0 (inactive)
    final int newStatus = (usedCount >= restrictedCount) ? 2 : 1;

    // Step 4: Update DB
    final res = await _client
        .from('promocode')
        .update({
          'used_count': usedCount,
          'updated_by': u.id,
          'status': newStatus,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id)
        .select('id, used_count, status')
        .maybeSingle();

    final ok = res != null;
    debugPrint(
        '[PromoCodeService] setStatus id=$id => used_count=$usedCount / restricted_count=$restrictedCount ${ok ? "OK" : "FAIL"}');
    return ok;
  } catch (e) {
    debugPrint('[PromoCodeService] setStatus error: $e');
    return false;
  }
}


  
}
