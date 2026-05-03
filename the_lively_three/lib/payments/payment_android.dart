import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'payment_service.dart';
import '../pages/subscription/subscription_model.dart';
import 'user_payment.dart'; // add this
import 'google_subscription_entitlement.dart';
import 'backend_subscription_api.dart';
import 'promo_code_service.dart';
import '../pages/subscription/subscription_helper.dart';
import 'package:the_lively_three/utils/error_log_service.dart';
import 'package:the_lively_three/payments/iap_failure.dart';
import 'subscription_data_helper.dart';

class AndroidSubscriptionPayment implements SubscriptionPaymentService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  final _msg = StreamController<String>.broadcast();

  Future<void> _sendError(String msg, {Object? error, StackTrace? st}) async {
    _msg.add('error:$msg'); // show on UI
    await ErrorLogService.logError(
        error ?? msg, st ?? StackTrace.current); // audit
  }

  SubscriptionPlan? _lastPlan;
  PromoCode? _lastPromoCode;

  // Add these new properties for subscription tracking
  final Map<String, String> _activeSubscriptions =
      {}; // purchaseToken -> productId
  bool _isSubscribed = false;

  String? _switchingFromToken;

  @override
  Stream<String> get messages => _msg.stream;

  Future<GooglePlayPurchaseDetails?> _findOldPurchaseForSwitch(
      {required String targetSku}) async {
    final androidAddition =
        _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    final past = await androidAddition.queryPastPurchases();

    final candidates = past.pastPurchases
        .whereType<GooglePlayPurchaseDetails>()
        .where((p) =>
            p.productID != targetSku &&
            (p.status == PurchaseStatus.purchased ||
                p.status == PurchaseStatus.restored ||
                p.status == PurchaseStatus.canceled))
        .toList();

    if (candidates.isEmpty) return null;

    for (final p in candidates) {
        final bc = p.billingClientPurchase;
        debugPrint('[IAP][candidate] sku=${p.productID}, ''status=${p.status}, ''autoRenew=${bc.isAutoRenewing}, ''ack=${bc.isAcknowledged}, '
          'token=${bc.purchaseToken}, ''time=${bc.purchaseTime}',
        );
      }

    candidates.sort((a, b) {
      final aTime = a.billingClientPurchase.purchaseTime ?? 0;
      final bTime = b.billingClientPurchase.purchaseTime ?? 0;
      return bTime.compareTo(aTime);
    });

    for (final p in candidates) {
      final token = p.billingClientPurchase.purchaseToken ?? '';
      final isActive = await UserPaymentService.isTokenActiveOnServer(token);
      debugPrint('[IAP][server-check] sku=${p.productID},token=$token, tokenActive=$isActive');
      if (isActive) {
        final selTime = p.billingClientPurchase.purchaseTime;
        debugPrint('[IAP] Switch candidate (SERVER ACTIVE) → ${p.productID} @ $selTime');
        return p;
      }
    }

    debugPrint('[IAP] No server-active old purchase → buy NEW (no switch)');
    return null;
  }

  @override
  Future<void> init() async {
    debugPrint('[IAP][Android] init() called');
    if (!Platform.isAndroid) {
      await _sendError('Not Android platform'); // was: _msg.add('error:...')
      debugPrint('[IAP][Android] Not Android platform');
      return;
    }
    
    final available = await _iap.isAvailable();
    debugPrint('[IAP][Android] isAvailable: $available');
    if (!available) {
      await _sendError('Play Billing not available on this device/account');
      return;
    }
    
    _sub = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (e, st) async {
        debugPrint('[IAP][Android] purchaseStream error: $e');
        await _sendError(e.toString(), error: e, st: st);
      },
    );
  }

  @override
  Future<void> buySubscription(
      SubscriptionPlan plan, PromoCode? promoCode) async {
    _lastPromoCode = promoCode;
    final String? offerId = promoCode?.offerId;
    _lastPlan = plan; // remember for callback
    debugPrint(
        '[IAP][Android] buySubscription(${plan.name}) start offerId=$offerId');

    try {
      // 1️⃣ Check billing availability
      final available = await _iap.isAvailable();
      debugPrint('[IAP][Android] isAvailable: $available');
      if (!available) {
        throw IapFailure('Play Billing not available on this device/account',
            code: 'billing-unavailable');
      }

      final idsToFetch = <String>{plan.androidSku};
      final oldPurchase =
          await _findOldPurchaseForSwitch(targetSku: plan.androidSku);
      if (oldPurchase != null) {
        _switchingFromToken =
            oldPurchase.verificationData.serverVerificationData;
        idsToFetch.add(oldPurchase.productID);
        debugPrint(
            '[IAP][Android] switching from old sku=${oldPurchase.productID}');
      } else {
        _switchingFromToken = null;
      }

      // 2️⃣ Query product details from Play
      debugPrint('[IAP][Android] querying product details for: ${idsToFetch.join(", ")}');
      final resp = await _iap.queryProductDetails(idsToFetch);
      debugPrint('[IAP][Android] query.notFound: ${resp.notFoundIDs}');
      debugPrint('[IAP][Android] query.error: ${resp.error}');
      if (resp.productDetails.isEmpty) {
        throw IapFailure('Product not found in Play: ${plan.androidSku}',
            code: 'product-not-found');
      }

      //final pd = resp.productDetails.first;
      final gpdsAll =
          resp.productDetails.whereType<GooglePlayProductDetails>().toList();
      if (gpdsAll.isEmpty) {
        throw IapFailure(
            'No Google Play product details for ${plan.androidSku}',
            code: 'no-googleplay-details');
      }

      final Map<String, GooglePlayProductDetails> byId = {
        for (final p in gpdsAll) p.id: p,
      };

      debugPrint('[IAP][Android] fetched: ${byId.keys.join(', ')}');
      if (!byId.containsKey(plan.androidSku)) {
        throw IapFailure('Product not found in Play: ${plan.androidSku}',code: 'product-not-found',);
      }
      final GooglePlayProductDetails pd = byId[plan.androidSku]!;

      debugPrint(
          '[IAP][Android] using product: ${pd.id} / ${pd.title} / ${pd.price}');
      // 3️⃣ Select the correct offer (promo or default)
      String? offerToken;

      if (pd is GooglePlayProductDetails) {
        final offers = pd.productDetails.subscriptionOfferDetails;
        var chosen;

        if (offers != null && offers.isNotEmpty) {
          debugPrint('[IAP][Android] Available Offers for ${pd.id}:');
          for (final o in offers) {
            debugPrint('➡️ basePlanId=${o.basePlanId}, '
                'offerIdToken=${o.offerIdToken}, '
                'tags=${o.offerTags}, '
                'pricingPhases=${o.pricingPhases.map((p) => "${p.priceCurrencyCode} ${(p.priceAmountMicros / 1000000.0)}").join(", ")}');
          }

          // ✅ Try to find promo offer
          if (offerId != null && offerId.trim().isNotEmpty) {
            final code = offerId.toLowerCase().trim();
            for (final o in offers) {
              final tags = (o.offerTags ?? const []);
              if (tags.any((t) => t.toLowerCase().trim() == code)) {
                chosen = o;
                break;
              }
            }
            if (chosen == null) {
              debugPrint(
                  '[IAP][Android] offerId "$offerId" not found → using full-price offer (baseplan)');
            }
          } else {
            debugPrint(
                '[IAP][Android] No offerId entered → using full-price offer (baseplan)');
          }

          // ✅ Single fallback for BOTH cases (no promo OR promo not found) → pick "baseplan"
          if (chosen == null) {
            for (final o in offers) {
              final tags = (o.offerTags ?? const []);
              if (tags.length == 1 &&
                  tags.first.toLowerCase().trim() == 'baseplan') {
                chosen = o;
                break;
              }
            }
          }

          // ✅ Apply selected offer if found
          if (chosen != null) {
            offerToken = chosen.offerIdToken;

            final phases = chosen.pricingPhases;
            if (phases.isNotEmpty) {
              final p0 = phases.first;
            }

            debugPrint(
                '[IAP][Android] offer selected: basePlanId=${chosen.basePlanId}, '
                'offerTags=${chosen.offerTags}, offerToken=$offerToken');
          } else {
            debugPrint(
                '[IAP][Android] No valid offer found, proceeding with base plan.');
          }
        }
      }

      final isSwitch =
          oldPurchase != null && oldPurchase.productID != plan.androidSku;
      final ChangeSubscriptionParam? changeParam = isSwitch
          ? ChangeSubscriptionParam(
              oldPurchaseDetails: oldPurchase!,
              replacementMode: ReplacementMode.withTimeProration)
          : null;

      // 4️⃣ Build GooglePlayPurchaseParam
      final appUserName = await UserPaymentService.appUserName();
      debugPrint(
          'appUserName=$appUserName  offerId=$offerId  offerToken=${offerToken != null ? 'set' : 'null'}');

      final param = GooglePlayPurchaseParam(
        productDetails: pd,
        offerToken: offerToken, // null => base plan
        changeSubscriptionParam: changeParam,
        applicationUserName: appUserName ?? "",
      );

      // 5️⃣ Launch purchase
      await _iap.buyNonConsumable(purchaseParam: param);
      debugPrint(
          '[IAP][Android] buyNonConsumable dispatched (offerId=$offerId, offerToken=${offerToken != null ? 'set' : 'null'})');
    } catch (e, st) {
      final msg = (e is IapFailure) ? e.message : 'Purchase failed: ${e.toString()}';
      await _sendError(msg, error: e, st: st);
      debugPrint('[IAP][Android][buySubscription] catch $msg');
      rethrow;
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> list) async {
    try {
      for (final d in list) {
        debugPrint('$d');
        debugPrint(
            '[IAP][Android] update status=${d.status} id=${d.purchaseID} pending=${d.pendingCompletePurchase}');
        switch (d.status) {
          case PurchaseStatus.pending:
            debugPrint('info:Purchase pending…'); 
            break;
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            try {
              if (d.pendingCompletePurchase) {
                await _iap.completePurchase(d);
                debugPrint('[IAP][Android] completePurchase done');
              }

              // Store the active subscription
              _activeSubscriptions[d.verificationData.serverVerificationData] =
                  d.productID;
              _isSubscribed = true;

              // ✅ Always verify with backend (new purchase OR restored)
              GoogleSubscriptionEntitlement? subscriptionEntitlement =
                  await BackendSubscriptionApi.verifyWithBackend(
                      token: d.verificationData.serverVerificationData);
              debugPrint('subscriptionEntitlement -  $subscriptionEntitlement');

              //CHECK WHEN BUY PLAN
              final plan = _lastPlan; // <-- read it here
              final promo = _lastPromoCode;

              if (plan != null && subscriptionEntitlement != null) {
                await SubscriptionDataHelper.saveSubscriptionToServer(
                  entitlement: subscriptionEntitlement,
                  plan: plan,
                  promo: promo,
                  purchaseToken: d.verificationData.serverVerificationData,
                  orderId: d.purchaseID,
                  platform: SubscriptionPlatformType.android,
                  oldTokenToMark: _switchingFromToken,
                );

                _switchingFromToken = null; // clear after handling
                _lastPlan = null;
                _lastPromoCode = null;

              } else {
                debugPrint(
                    '[IAP][Android] WARN: _lastPlan is null. Call buySku(SubscriptionPlan) to set it before purchase.');
              }
              _msg.add('ok:Subscription active');
            } catch (e,st) {
              final msg = (e is IapFailure) ? e.message : 'Acknowledge/verify failed: ${e.toString()}';
              await _sendError(msg, error: e, st: st);
              debugPrint('[IAP][Android] acknowledge/verify error: $e');
            }
            break;
          case PurchaseStatus.canceled:
            if (d.pendingCompletePurchase) {
              await _iap.completePurchase(d);
            }
            _msg.add('info:Purchase cancelled');
            break;
          case PurchaseStatus.error:
            if (d.pendingCompletePurchase) {
              await _iap.completePurchase(d);
            }
            
            // show on UI + audit to table
            final errMsg = d.error?.message ?? d.error?.toString() ?? 'Unknown purchase error';
            await _sendError(errMsg, error: d.error, st: StackTrace.current);
            debugPrint('[IAP][Android] status error: ${d.error}');
            break;
            
        }
      }
    } catch (e, st) {
      final msg = (e is IapFailure) ? e.message : 'Acknowledge/verify failed: ${e.toString()}';
      await _sendError(msg, error: e, st: st);
      debugPrint('[IAP][Android] acknowledge/verify error: $e');
      rethrow;
    }
  }

  @override
Future<void> cancelSubscription(String cancelReason) async {
  try {
    final token = await UserPaymentService.getLatestPurchaseTokenForCurrentUser();
    if (token == null) {
      throw IapFailure('No active subscription/purchase token found', code: 'no-token');
    }

    final GoogleSubscriptionEntitlement? subscriptionEntitlement =
        await BackendSubscriptionApi.cancelWithBackend(token: token);
    debugPrint('subscriptionEntitlement - $subscriptionEntitlement');

    if (subscriptionEntitlement == null) {
      throw IapFailure('Cancellation failed: no entitlement returned from backend', code: 'cancel-null');
    }

    await SubscriptionDataHelper.updateSubscriptionStatusOnServer(
        purchaseToken: token,
        status: subscriptionEntitlement.status,
        cancelReason: cancelReason,
      );

    // Unknown status → log for devs, do NOT emit to UI
    debugPrint('[IAP] cancelSubscription warn: unknown status "${subscriptionEntitlement.status}"');

  } catch (e, st) {
    final msg = (e is IapFailure) ? e.message : 'Cancellation failed: ${e.toString()}';
    await _sendError(msg, error: e, st: st); // shows on UI + audits
    rethrow;
  }
}


  @override
  Future<void> switchSubscription(SubscriptionPlan plan) async {
    try {
      //need to call swith it take base plan only not least price one
      buySubscription(plan, null);
    } catch (e,st) {
      debugPrint('[IAP] switchSubscription error: $e');
      await _sendError(e.toString(), error: e, st: st);
    }
  }

  @override
  void dispose() {
    debugPrint('[IAP][Android] dispose()');
    _sub?.cancel();
    _msg.close();
  }
}
