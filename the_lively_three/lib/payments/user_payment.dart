import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/subscription/subscription_helper.dart' as subHelper;
import 'user_subscription_status.dart';

enum UpdatedSource {
  flutter(1),
  androidRTDN(2),
  iosRTDN(3);

  final int value;
  const UpdatedSource(this.value);
}


/// Inserts one row into public.user_payment (or upserts by purchase_token).
class UserPaymentService {
  /// Call this right after a successful purchase.
  static Future<bool> insertPayment({
    required int subscriptionId,
    required int originalSubscriptionId,          // DB plan id
    required String subscriptionName,     // plan name
    required double subscriptionPrice,    // plan price
    required String subscriptionCurrency, // plan currency
    required int platform,
    required String subscriptionStatus,
    String? orderId,
    DateTime? subscribedAt,                     // GPA-... (optional)
    DateTime? expiresAt,  
    String? productId,            // set later from server if unknown
    String? purchaseToken,  
    // ✅ NEW: actual amount Google charged at checkout
    double? chargedPrice,
    String? chargedCurrency,
                  // <-- NEW: Google Play token
    bool? isSubscriptionAutoRenew,
    String? taxCurrencyCode,
    bool? isTaxInclusive,
    String? promocode,
    String? offerId, 
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('[user_payment] No logged-in user');
        return false;
      }

      //final DateTime? computedExpiry = expiresAt ?? subHelper.computeExpiryFromName(subscriptionName);
      final nowIso = DateTime.now().toUtc().toIso8601String();

      final payload = <String, dynamic>{
        'user_id': user.id,
        'subscription_id': subscriptionId,
        'original_subscription_id': originalSubscriptionId,
        'subscription_name': subscriptionName,
        'subscription_price': subscriptionPrice,
        'subscription_currency': subscriptionCurrency,
        'platform': platform,
        'subscription_status': subscriptionStatus,
        'updated_at': nowIso,
        'updated_source': UpdatedSource.flutter.value,
        if (orderId != null) 'order_id': orderId,
        if (subscribedAt != null)
          'subscribed_at': subscribedAt.toUtc().toIso8601String(),
        if (expiresAt != null)
          'expires_at': expiresAt.toUtc().toIso8601String(),
        if (productId != null) 'product_id': productId,
        if (purchaseToken != null) 'purchase_token': purchaseToken, // NEW
        if (chargedPrice    != null) 'charged_price'    : chargedPrice,
        if (chargedCurrency != null) 'charged_currency' : chargedCurrency,
        if (isSubscriptionAutoRenew != null) 'isSubscriptionAutoRenew': isSubscriptionAutoRenew,
        if (promocode != null) 'promocode'  : promocode,
        if (offerId != null) 'offer_id' : offerId,
      };

      final tbl = Supabase.instance.client.from('user_payment');

      // If we have a token and a UNIQUE index on purchase_token, upsert to avoid duplicates.
      final inserted = purchaseToken != null
          ? await tbl.upsert(payload, onConflict: 'purchase_token').select('id').maybeSingle()
          : await tbl.insert(payload).select('id').maybeSingle();

      final ok = inserted != null;
      debugPrint('[user_payment] ${purchaseToken != null ? "upsert" : "insert"} ${ok ? "OK" : "FAILED"} payload=$payload');

      if (ok) {

         try {
          final int? paymentId = (inserted['id'] as int?);
          if (paymentId != null && purchaseToken != null && orderId != null) {
            final detail = <String, dynamic>{
              'user_payment_id': paymentId,
              'user_id'        : user.id,
              'purchase_token' : purchaseToken,
              'order_id'       : orderId,
              'updated_at'     : nowIso,
              'updated_source' : UpdatedSource.flutter.value,
              'original_subscription_id': originalSubscriptionId,
              if (productId    != null) 'product_id'   : productId,
              if (subscribedAt != null) 'subscribed_at': subscribedAt.toUtc().toIso8601String(),
              if (expiresAt    != null) 'expires_at'   : expiresAt.toUtc().toIso8601String(),
              if (chargedPrice        != null) 'charged_price'         : chargedPrice,
              if (chargedCurrency != null) 'charged_currency' : chargedCurrency,
              if (taxCurrencyCode     != null) 'tax_currency_code'     : taxCurrencyCode,
              if (isTaxInclusive      != null) 'is_tax_inclusive'      : isTaxInclusive,
              if (promocode != null) 'promocode'  : promocode,
              if (offerId != null) 'offer_id' : offerId,
            };

            // Upsert to avoid duplicate (purchase_token, order_id) if the same confirm arrives twice
            await Supabase.instance.client
                .from('user_payment_detail')
                .upsert(
                  detail,
                  onConflict: 'purchase_token,order_id',
                  ignoreDuplicates: true,
                );
          }
        } catch (e) {
          debugPrint('[user_payment_detail] insert mirror failed: $e');
        }


        final usersUpdate = <String, dynamic>{
          'has_subscription': true,
          'subscription_id' : subscriptionId,
          'original_subscription_id' : originalSubscriptionId,
          'updated_at': nowIso,
          'updated_source': UpdatedSource.flutter.value,
          if (expiresAt != null)
            'subscription_expires_at': expiresAt.toUtc().toIso8601String(),//computedExpiry
          if (isSubscriptionAutoRenew != null)
            'isSubscriptionAutoRenew': isSubscriptionAutoRenew,
          
        };
        try {
          await Supabase.instance.client.from('users').update(usersUpdate).eq('id', user.id);
        } catch (e) {
          debugPrint('[user_payment] users update failed: $e');
        }
      }

      return ok;
    } catch (e) {
      debugPrint('[user_payment] insert error: $e');
      return false;
    }
  }


static Future<bool> updateStatusByPurchaseToken({
  required String purchaseToken,
  required String subscriptionStatus,
  DateTime? subscriptionCancelledOn,
  String ? reasonForCancellation,
}) async {
  try {
    
    final user   = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint('[user_payment] cancel: no logged-in user');
      return false;
    }

    final nowIso = DateTime.now().toUtc().toIso8601String(); 

    final res = await Supabase.instance.client
        .from('user_payment')
        .update({
          'subscription_status': subscriptionStatus,
          'updated_at': nowIso,
          'updated_source': UpdatedSource.flutter.value,
          if (subscriptionStatus == "expired" || subscriptionStatus == "cancelled" || subscriptionStatus == "planChange")
          'isSubscriptionAutoRenew': false,
          if (subscriptionCancelledOn != null)
          'subscription_cancelled_on': subscriptionCancelledOn.toUtc().toIso8601String(),
        if (reasonForCancellation != null)
          'reason_for_cancellation': reasonForCancellation,
        })
        .eq('purchase_token', purchaseToken)
        .select('id')
        .maybeSingle();

    final ok = res != null;
    debugPrint('[user_payment] status update ${ok ? "OK" : "NO ROW"} token=$purchaseToken -> $subscriptionStatus');

    if ((subscriptionStatus == "expired" || subscriptionStatus == "cancelled") && ok) {
      try {
        await Supabase.instance.client
            .from('users')
            .update({
                'isSubscriptionAutoRenew': false,
                'updated_at': nowIso, 
                'updated_source': UpdatedSource.flutter.value,
              })
            .eq('id', user.id);
      } catch (e) {
        debugPrint('[user_payment] users mirror (autoRenew=false) failed: $e');
      }
    }

    return ok;
  } catch (e) {
    debugPrint('[user_payment] status update error: $e');
    return false;
  }
}


static Future<bool> updateReasonForCancellation({
  required String purchaseToken,
  DateTime? subscriptionCancelledOn,
  String ? reasonForCancellation,
  }) async {
    try {
      
      final user   = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('[user_payment] cancel: no logged-in user');
        return false;
      }

      final nowIso = DateTime.now().toUtc().toIso8601String(); 

      final res = await Supabase.instance.client
          .from('user_payment')
          .update({
            'updated_at': nowIso,
            'updated_source': UpdatedSource.flutter.value,
            if (subscriptionCancelledOn != null)
            'subscription_cancelled_on': subscriptionCancelledOn.toUtc().toIso8601String(),
            if (reasonForCancellation != null)
              'reason_for_cancellation': reasonForCancellation,
            })
          .eq('purchase_token', purchaseToken)
          .select('id')
          .maybeSingle();

      final ok = res != null;
      debugPrint('[user_payment] status update ${ok ? "OK" : "NO ROW"} token=$purchaseToken -> $reasonForCancellation');
      return ok;
    } catch (e) {
      debugPrint('[user_payment] status update error: $e');
      return false;
    }
  }

  /// Reads subscription state ONLY from public.users.
  static Future<UserSubscriptionStatus> getCurrentSubscriptionFromUsers(locale) async {
    final client = Supabase.instance.client;
    final user   = client.auth.currentUser;
    if (user == null) return UserSubscriptionStatus.empty;

    try {
      final row = await client
          .from('users')
          .select('has_subscription, subscription_id,original_subscription_id, subscription_expires_at, isSubscriptionAutoRenew')
          .eq('id', user.id)
          .maybeSingle();

      if (row == null) return UserSubscriptionStatus.empty;

      final hasSub   = (row['has_subscription'] ?? false) as bool;
      int? subId          = row['subscription_id'] as int?;            // <-- not final
      final originalSubId    = row['original_subscription_id'] as int?;
      final expStr   = row['subscription_expires_at'] as String?;
      final expAt    = expStr != null ? DateTime.parse(expStr).toUtc() : null;
      final autoRenew = row['isSubscriptionAutoRenew'] as bool?;

      // Look up plan name if we have an id
      String? subName;
      if (originalSubId != null) {
        final subRow = await client
            .from('subscription')
            .select('id, name')
            .eq('original_subscription_id', originalSubId)
            .eq('locale', locale)
            .maybeSingle();
        subName = (subRow?['name'] as String?);
        subId = (subRow?['id'] as int?);
        debugPrint('[sub][users] plan lookup: id=$subId originalSubId=$originalSubId locale=$locale => name=$subName');
      }

      final nowUtc   = DateTime.now().toUtc();
      final active   = expAt != null && nowUtc.isBefore(expAt);
      final isSub    = hasSub && active;

      final status   = !hasSub
          ? 'none'
          : (active ? 'active' : 'expired');

      debugPrint('[sub][users] hasSub=$hasSub subId=$subId originalSubId=$originalSubId name=$subName '
               'expAt=$expAt now=$nowUtc active=$active status=$status');

      return UserSubscriptionStatus(
        isSubscribed: isSub,
        subscriptionId: subId,
        originalSubscriptionId: originalSubId,
        subscriptionName: subName, // model can fill from plans list
        expiresAt: expAt,
        status: status,
        isSubscriptionAutoRenew: autoRenew,
      );
    } catch (e) {
      debugPrint('[user_payment] read users failed: $e');
      return UserSubscriptionStatus.empty;
    }
  }



  static Future<String?> getLatestPurchaseTokenForCurrentUser() async {
  try {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) return null;

    final row = await client
        .from('user_payment')
        .select('purchase_token, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final token = row?['purchase_token'] as String?;
    if (token == null || token.isEmpty) {
      debugPrint('[user_payment] no latest purchase_token found');
      return null;
    }
    return token;
  } catch (e) {
    debugPrint('[user_payment] getLatestPurchaseTokenForCurrentUser error: $e');
    return null;
  }
}


static Future<String?> appUserName() async {
    try {
      final client = Supabase.instance.client;
      final u = client.auth.currentUser;
      if (u == null) return null;

      final row = await client
          .from('users')
          .select('firstname,email')
          .eq('id', u.id)
          .maybeSingle();

      if (row == null) return 'uid:${u.id}';

      final String? first = (row['firstname'] as String?)?.trim();
      final String? email = (row['email'] as String?)?.trim();

      if ((first?.isNotEmpty ?? false) && (email?.isNotEmpty ?? false)) {
        return first!.toLowerCase();   // If you ONLY need firstname (lowercase)
        // return '$email - $first'.toLowerCase();  // If you want combination
      }

      if (email?.isNotEmpty ?? false) {
        return email!.toLowerCase();
      }

      if (first?.isNotEmpty ?? false) {
        return first!.toLowerCase();
      }

      return 'uid:${u.id}';
    } catch (e) {
      debugPrint('[UserPaymentService] buildApplicationUserName error: $e');
      return null;
    }
  }


 static  Future<bool> isTokenActiveOnServer(String token) async {
    if (token.isEmpty) return false;

    final sb = Supabase.instance.client;

    // Get the most recent record for this purchase token
    final data = await sb
        .from('user_payment')
        .select('subscription_status, expires_at')
        .eq('purchase_token', token)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return false;

    final status = (data['subscription_status'] as String?)?.toLowerCase() ?? '';
    final expiresAtStr = data['expires_at'] as String?;
    final expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

    final nowUtc = DateTime.now().toUtc();

    // Treat active if NOT expired and status not marked expired/canceled
    final notExpired = expiresAt != null ? expiresAt.isAfter(nowUtc) : false;

    final statusOk = !(status == 'expired');

    return notExpired && statusOk;
  }

}
