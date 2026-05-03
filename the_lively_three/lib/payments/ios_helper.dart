// lib/payments/ios_helper.dart

import 'dart:math';                          // for Random.secure()
import 'package:flutter/foundation.dart';    // for debugPrint

import 'package:the_lively_three/payments/ios_promo_signature.dart';
import 'backend_subscription_api.dart';
import 'package:the_lively_three/utils/error_log_service.dart';

/// UUID v4 generator (moved out of IOSSubscriptionPayment).
String generateUuidV4() {                    // [NEW]
  final r = Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));

  // Per RFC 4122: set version (4) and variant (10x).
  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  bytes[8] = (bytes[8] & 0x3F) | 0x80;

  String hex(int b) => b.toRadixString(16).padLeft(2, '0');
  final h = bytes.map(hex).join();
  return '${h.substring(0, 8)}-'
      '${h.substring(8, 12)}-'
      '${h.substring(12, 16)}-'
      '${h.substring(16, 20)}-'
      '${h.substring(20, 32)}';
}

/// Ask backend for an Apple promotional-offer signature.
/// (moved from IOSSubscriptionPayment)
Future<IosPromoSignature?> requestPromoSignature({   // [NEW]
  required String productId,
  required String offerIdentifier,
  required String? applicationUserName
}) async {
  try {
    final sig = await BackendSubscriptionApi.getIosPromoSignature(
      productId: productId,
      offerIdentifier: offerIdentifier,
      applicationUserName: applicationUserName ?? '',
    );

    if (sig == null ||
        sig.keyIdentifier.isEmpty ||
        sig.signature.isEmpty) {
      debugPrint('[IAP][iOS] promo signature: empty/invalid');
      return null;
    }

    return sig;
  } catch (e, st) {
    debugPrint('[IAP][iOS] Promo signature fetch failed: $e');
    await ErrorLogService.logError(e, st);  // replaces _sendError
    return null; // fallback to full price
  }
}
