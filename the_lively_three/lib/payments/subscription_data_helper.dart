import 'package:flutter/foundation.dart';
import '../pages/subscription/subscription_model.dart';
import 'promo_code_service.dart';
import 'user_payment.dart';
import 'google_subscription_entitlement.dart';

class SubscriptionDataHelper {
  
  static Future<void> saveSubscriptionToServer({
    required GoogleSubscriptionEntitlement entitlement,
    required SubscriptionPlan plan,
    required PromoCode? promo,
    required String purchaseToken,
    required String? orderId,
    required int platform, // e.g. SubscriptionPlatform.android / ios
    String? oldTokenToMark,
  }) async {
    
    debugPrint('[IAP][saveSubscriptionToServer] → started for ${plan.name} ($platform)');
    final actualChargedPrice = entitlement.chargedUnits ?? 0;
    final actualChargedCurrency = entitlement.chargedCurrencyCode;

    debugPrint('[IAP] chargedPrice=$actualChargedPrice $actualChargedCurrency, orderId=${orderId ?? purchaseToken}');
    
    debugPrint('[IAP] inserting payment record...');
    await UserPaymentService.insertPayment(
      subscriptionId: plan.id,
      originalSubscriptionId: plan.originalSubscriptionId,
      subscriptionName: plan.name,
      subscriptionPrice: plan.price.toDouble(),
      subscriptionCurrency: plan.currency,
      platform: platform,
      subscriptionStatus: entitlement.status,
      orderId: orderId ?? purchaseToken,
      subscribedAt: entitlement.subscribedAt,
      expiresAt: entitlement.expiresAt,
      productId: entitlement.productId,
      purchaseToken: purchaseToken,
      chargedPrice: actualChargedPrice,
      chargedCurrency: actualChargedCurrency,
      isSubscriptionAutoRenew: entitlement.isSubscriptionAutoRenew,
      taxCurrencyCode: entitlement.taxCurrencyCode,
      isTaxInclusive: entitlement.isTaxInclusive,
      promocode: promo?.promocode,
      offerId: promo?.offerId,
    );
    
    debugPrint('[IAP] insertPayment ✅ done');
    // 🔗 Link old token when user switched plans
    if (oldTokenToMark != null && oldTokenToMark.isNotEmpty) {
      debugPrint('[IAP] linking oldToken=$oldTokenToMark → newToken=$purchaseToken');
      try {
        await UserPaymentService.updateStatusByPurchaseToken(
          purchaseToken: oldTokenToMark,
          subscriptionStatus: 'planChange',
          subscriptionCancelledOn: DateTime.now(),
          reasonForCancellation: 'new purchase token $purchaseToken',
        );
        debugPrint('[IAP] oldToken link ✅ success');
      } catch (e) {
        debugPrint('[IAP][Helper] Failed to link old→new token: $e');
      }
    } else {
      debugPrint('[IAP] no oldTokenToMark provided');
    }

    // ✅ Mark promo code used
    if (promo != null) {
      debugPrint('[IAP] marking promo used: ${promo.promocode}');
      await PromoCodeService.markPromoUsed(id: promo.id);
      debugPrint('[IAP] promo used ✅');
    }else {
      debugPrint('[IAP] no promo to mark');
    }
  }

  /// Update the subscription status in DB after backend-confirmed
  /// cancel or expiry events.
  static Future<void> updateSubscriptionStatusOnServer({
    required String purchaseToken,
    required String status, // 'cancelled' | 'expired' | others ignored
    String? cancelReason,
  }) async {
    if (status == 'cancelled') {
      await UserPaymentService.updateStatusByPurchaseToken(
        purchaseToken: purchaseToken,
        subscriptionStatus: status,
        subscriptionCancelledOn: DateTime.now(),
        reasonForCancellation: cancelReason ?? 'user request',
      );
      return;
    }

    if (status == 'expired') {
      await UserPaymentService.updateStatusByPurchaseToken(
        purchaseToken: purchaseToken,
        subscriptionStatus: status,
      );
      return;
    }

    debugPrint('[IAP][Helper] Ignored unknown cancel status: "$status"');
  }

  static Future<void> updateReasonForCancellation({
    required String purchaseToken,
    String? cancelReason,
  }) async {
      await UserPaymentService.updateReasonForCancellation(
        purchaseToken: purchaseToken,
        subscriptionCancelledOn: DateTime.now(),
        reasonForCancellation: cancelReason ?? 'user request',
      );
      return;
  }



}
