import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'google_subscription_entitlement.dart';
import 'package:the_lively_three/payments/ios_promo_signature.dart';


class BackendSubscriptionApi {
  // Keep package name here so the moved functions work 1:1
  static const String _packageName = 'eco.intenomics.thelivelythree.v1';

  // === your _verifyWithBackend moved here, body unchanged except static/class context ===
  static Future<GoogleSubscriptionEntitlement?> verifyWithBackend({
    required String token,
  }) async {
    try {
      const anonKey =
          '#';
      debugPrint('anon token $anonKey');
      final resp = await Supabase.instance.client.functions.invoke(
        'play-verify',
        body: {
          'purchaseToken': token,
          'packageName': _packageName,
          'productId': null,
        },
        headers: {
          'Authorization': 'Bearer $anonKey',
          'x-hook-secret': '#',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('info:Verification requested');

      final map = (resp.data as Map).cast<String, dynamic>();
      if (resp.status != 200 || map['ok'] != true) return null;

      final norm = map['normalized'] as Map<String, dynamic>?;
      return norm == null
          ? null
          : GoogleSubscriptionEntitlement.fromNormalized(norm);
    } catch (e, st) {
      debugPrint('[IAP][Android] verify error: $e');
      // caller keeps its own _sendError logic; we just rethrow as before
      rethrow;
    }
  }

  // === your _cancelWithBackend moved here, body unchanged except static/class context ===
  static Future<GoogleSubscriptionEntitlement?> cancelWithBackend({
    required String token,
  }) async {
    try {
      const anonKey =
          '#';
      debugPrint('anon token $anonKey');
      final resp = await Supabase.instance.client.functions.invoke(
        'play-cancel',
        body: {
          'purchaseToken': token,
          'packageName': _packageName,
          'productId': null,
        },
        headers: {
          'Authorization': 'Bearer $anonKey',
          'x-hook-secret': '#',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('info:Cancellation requested');

      final map = (resp.data as Map).cast<String, dynamic>();
      if (resp.status != 200 || map['ok'] != true) {
        debugPrint('[IAP][Android] cancel error: status=${resp.status} data=$map');
        return null;
      }

      final norm = map['normalized'] as Map<String, dynamic>?;
      if (norm == null) {
        debugPrint('[IAP][Android] cancel error: normalized missing');
        return null;
      }

      final ent = GoogleSubscriptionEntitlement.fromNormalized(norm);
      debugPrint('[IAP][Android] cancel -> status=${ent.status} exp=${ent.expiresAt}');
      return ent;
    } catch (e, st) {
      debugPrint('[IAP][Android] cancel error: $e');
      // caller keeps its own _sendError logic; we just rethrow as before
      rethrow;
    }
  }


  static Map<String, dynamic> decodeJwtPayload(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) throw Exception('Invalid JWT token');
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[IAP][Apple] JWT decode failed: $e');
      return {};
    }
  }


  // === iOS (Apple) verification ==============================================
  // static Future<GoogleSubscriptionEntitlement?> verifyWithApple({
  //   required String receiptData,
  //   bool isSandbox = true,
  // }) async {
  //   try {
  //     const anonKey =
  //         '#';
  //     debugPrint('anon token $anonKey');

  //     final resp = await Supabase.instance.client.functions.invoke(
  //       'apple-verify',
  //       body: {
  //         'receiptData': receiptData,
  //         'isSandbox': isSandbox,
  //       },
  //       headers: {
  //         'Authorization': 'Bearer $anonKey',
  //         'x-hook-secret': '#',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     debugPrint('info:[Apple] Verification requested');

  //     final map = (resp.data as Map).cast<String, dynamic>();
  //     if (resp.status != 200 || map['ok'] != true) {
  //       debugPrint('[IAP][Apple] verify error: ${resp.status} data=$map');
  //       return null;
  //     }

  //     final norm = map['normalized'] as Map<String, dynamic>?;
  //     return norm == null
  //         ? null
  //         : GoogleSubscriptionEntitlement.fromNormalized(norm);
  //   } catch (e, st) {
  //     debugPrint('[IAP][Apple] verify error: $e');
  //     rethrow;
  //   }
  // }

  static Future<GoogleSubscriptionEntitlement?> verifyWithApple({
  required String signedTransactionInfo,
}) async {
  final functions = Supabase.instance.client.functions;

  // your anon KEY (same as Android uses)
  const anonKey =
      '#';

  final response = await functions.invoke(
    'apple-verify',
    body: {
      'signedTransactionInfo': signedTransactionInfo,
    },
    headers: {
      'Authorization': 'Bearer $anonKey',
      'x-hook-secret': '#',
      'Content-Type': 'application/json',
    },
  );

  final data = response.data as Map<String, dynamic>?;
  if (data == null || data['entitlement'] == null) return null;

  final e = data['entitlement'] as Map<String, dynamic>;

  return GoogleSubscriptionEntitlement(
    productId: e['productId'] ?? '',
    chargedUnits: (e['chargedUnits'] ?? 0.0).toDouble(),
    chargedCurrencyCode: e['chargedCurrencyCode'] ?? '',
    subscribedAt: DateTime.parse(e['subscribedAt']),
    expiresAt: DateTime.parse(e['expiresAt']),
    //subscribedAt:
    //    DateTime.fromMillisecondsSinceEpoch(e['subscribedAtMs'], isUtc: true),
    //expiresAt:
    //    DateTime.fromMillisecondsSinceEpoch(e['expiresAtMs'], isUtc: true),
    status: e['status'] ?? 'UNKNOWN',
    isSubscriptionAutoRenew: e['isSubscriptionAutoRenew'] ?? false,
    originalTransactionId: e['originalTransactionId'],
    transactionId: e['transactionId'],
    autoRenewProductId: e['autoRenewProductId'],
  );
}



    // === iOS (Apple) promotional offer signature ===============================
  static Future<IosPromoSignature?> getIosPromoSignature({
  required String productId,
  required String offerIdentifier,
  required String applicationUserName
}) async {
  try {
    const anonKey =
        '#';
    
    // ⭐ PRINT ALL INPUT PARAMETERS
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[Apple Promo Signature] 📤 REQUEST PARAMETERS:');
    debugPrint('  productId: $productId');
    debugPrint('  offerIdentifier: $offerIdentifier');
    debugPrint('  applicationUserName: $applicationUserName');
    debugPrint('  anonKey: ${anonKey.substring(0, 50)}...');
    debugPrint('═══════════════════════════════════════════════════════');

    // 👇 Name this Edge Function whatever you actually deploy in Supabase
    final resp = await Supabase.instance.client.functions.invoke(
      'ios-promo-signature', // e.g. supabase/functions/ios-promo-signature
      body: {
        'productId': productId,
        'offerIdentifier': offerIdentifier,
        'applicationUserName': applicationUserName,
      },
      headers: {
        'Authorization': 'Bearer $anonKey',
        'x-hook-secret': '#',
        'Content-Type': 'application/json',
      },
    );

    // ⭐ PRINT RESPONSE STATUS
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[Apple Promo Signature] 📥 RESPONSE:');
    debugPrint('  HTTP Status: ${resp.status}');
    debugPrint('  Response Data Type: ${resp.data.runtimeType}');
    debugPrint('  Raw Response: ${resp.data}');
    
    final map = (resp.data as Map).cast<String, dynamic>();
    
    // ⭐ PRINT ALL RESPONSE FIELDS
    debugPrint('  Parsed Map Keys: ${map.keys.toList()}');
    debugPrint('  ok: ${map['ok']}');
    debugPrint('  keyIdentifier: ${map['keyIdentifier']}');
    debugPrint('  signature (first 50 chars): ${(map['signature'] as String?)?.substring(0, 50) ?? 'null'}...');
    
    // Print all additional fields if any
    map.forEach((key, value) {
      if (key != 'ok' && key != 'keyIdentifier' && key != 'signature') {
        debugPrint('  $key: $value');
      }
    });
    debugPrint('═══════════════════════════════════════════════════════');

    // Check response validity
    if (resp.status != 200 || map['ok'] != true) {
      debugPrint('[IAP][Apple] ❌ promo-signature error: ${resp.status} data=$map');
      return null;
    }

    final keyId = (map['keyIdentifier'] as String?) ?? '';
    final sig = (map['signature'] as String?) ?? '';
    final nonce = (map['nonce'] as String?) ?? '';
    final ts = (map['timestamp'] as num?)?.toInt() ?? 0;

    if (keyId.isEmpty || sig.isEmpty) {
      debugPrint('[IAP][Apple] ❌ promo-signature error: keyIdentifier/signature missing');
      debugPrint('  keyIdentifier isEmpty: ${keyId.isEmpty}');
      debugPrint('  signature isEmpty: ${sig.isEmpty}');
      return null;
    }

    // ⭐ PRINT FINAL RESULT
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[Apple Promo Signature] ✅ SUCCESS:');
    debugPrint('  keyIdentifier: $keyId');
    debugPrint('  signature length: ${sig.length} chars');
    debugPrint('  nonce: $nonce');
    debugPrint('  timestampMs: $ts');
    debugPrint('═══════════════════════════════════════════════════════');

    return IosPromoSignature(
      keyIdentifier: keyId,
      signature: sig,
      nonce: nonce,
      timestampMs: ts,
    );
  } catch (e, st) {
    // ⭐ PRINT ERROR DETAILS
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[IAP][Apple] ❌ EXCEPTION in promo-signature:');
    debugPrint('  Error: $e');
    debugPrint('  Error Type: ${e.runtimeType}');
    debugPrint('  Stack Trace:');
    debugPrint(st.toString());
    debugPrint('═══════════════════════════════════════════════════════');
    rethrow;
  }
}


}
