import 'dart:async';
import 'dart:io'; 

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart'; 
import 'package:the_lively_three/payments/ios_promo_signature.dart';
import 'ios_helper.dart';

import 'google_subscription_entitlement.dart';
import 'package:flutter/services.dart';

import 'payment_service.dart';
import '../pages/subscription/subscription_model.dart';
import 'user_payment.dart';
import 'backend_subscription_api.dart';
import 'promo_code_service.dart';
import '../pages/subscription/subscription_helper.dart';
import 'package:the_lively_three/utils/error_log_service.dart';
import 'package:the_lively_three/payments/iap_failure.dart';
import 'subscription_data_helper.dart';
import 'package:url_launcher/url_launcher.dart';


/// iOS counterpart to AndroidSubscriptionPayment with StoreKit extras in use.
/// Apple auto-handles upgrades/downgrades within the same Subscription Group.
/// You cannot pass an Android-like offer token; use intro/promotional/offer codes instead.
class IOSSubscriptionPayment implements SubscriptionPaymentService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  final _msg = StreamController<String>.broadcast();

  SubscriptionPlan? _lastPlan;
  PromoCode? _lastPromoCode;

  // Parity tracking with Android (optional, but kept)
  final Map<String, String> _activeSubscriptions = {}; // receipt/token -> productId
  bool _isSubscribed = false;

  String? _expectedProductId;        // which product (sku) we are buying right now
  bool _purchaseFlowActive = false;

  @override
  Stream<String> get messages => _msg.stream;

  Future<void> _sendError(String msg, {Object? error, StackTrace? st}) async {
    _msg.add('error:$msg');
    await ErrorLogService.logError(error ?? msg, st ?? StackTrace.current);
  }

  // Build SKPaymentDiscountWrapper if a promo code with offerId is present.
  Future<SKPaymentDiscountWrapper?> _buildDiscountIfAny({
    required ProductDetails pd,
    required String applicationUserName,
    required PromoCode? promo,
    
  }) async {
    final offerId = (promo?.offerId ?? '').trim();
    if (offerId.isEmpty) return null;

    final nonce = generateUuidV4(); // UUID
    final tsMs = DateTime.now().millisecondsSinceEpoch;
    final appUserName = applicationUserName;

    final sig = await requestPromoSignature(
      productId: pd.id,
      offerIdentifier: offerId,
      applicationUserName: appUserName,
    );

    if (sig == null) return null; // fallback

    debugPrint('[IAP][iOS][DISCOUNT] promo signature result => '
           'sig=${sig?.signature.substring(0,10)}..., '
           'keyId=${sig?.keyIdentifier}, '
           'isNull=${sig == null}');

    debugPrint('[IAP][iOS][DISCOUNT] Building SKPaymentDiscountWrapper → '
           'id=$offerId, '
           'keyId=${sig.keyIdentifier}, '
           'nonce=$nonce, '
           'timestamp=$tsMs');

    final discount = SKPaymentDiscountWrapper( // [ADD]
      identifier: offerId,                 // Offer Identifier (ASC)
      keyIdentifier: sig.keyIdentifier,    // Key ID from ASC
      nonce: nonce,                        // the UUID we generated
      signature: sig.signature,            // Base64 signature from server
      timestamp: tsMs,                     // ms since epoch
    );

    debugPrint('[IAP][iOS] Built discount for $offerId (keyId=${sig.keyIdentifier})');
    return discount;
  }

  Future<SK2PromotionalOffer?> _buildSk2PromotionalOfferIfAny({
    required ProductDetails pd,
    required String applicationUserName,
    required PromoCode? promo,
  }) async {
    final offerId = (promo?.offerId ?? '').trim();
    if (offerId.isEmpty) return null;

    // Generate nonce + timestamp to send to your backend
    //final nonce = generateUuidV4();
    //final tsMs = DateTime.now().millisecondsSinceEpoch;

    debugPrint('[IAP][iOS][SK2] building promo offer → '
        'offerId=$offerId');

    final sig = await requestPromoSignature(
      productId: pd.id,
      offerIdentifier: offerId,
      applicationUserName: applicationUserName,
    );

    if (sig == null) {
      debugPrint('[IAP][iOS][SK2] promo signature is null → fallback to full price');
      return null;
    }

    debugPrint('[IAP][iOS][SK2] promo signature result => '
        'sig=${sig.signature.substring(0, 10)}..., '
        'keyId=${sig.keyIdentifier}'
        'timestamp=${sig.timestampMs}'
        'signature=${sig.signature}');

    // For SK2 we must wrap the server signature in SK2SubscriptionOfferSignature
    final offerSignature = SK2SubscriptionOfferSignature(
      keyID: sig.keyIdentifier,
      nonce: sig.nonce,
      timestamp: sig.timestampMs,
      signature: sig.signature,
    );

    final promoOffer = SK2PromotionalOffer(
      offerId: offerId,
      signature: offerSignature,
    );

    debugPrint('[IAP][iOS][SK2] Built SK2PromotionalOffer for $offerId '
        '(keyId=${sig.keyIdentifier})');

    return promoOffer;
  }


void _attachListenerForFlow() {
    _sub?.cancel();
    _sub = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (e, st) async {
        debugPrint('[IAP][iOS] purchaseStream error: $e');
        await _sendError(e.toString(), error: e, st: st);
        _detachListener();
      },
      onDone: _detachListener,
    );
  }

  void _detachListener() {
    _sub?.cancel();
    _sub = null;
  }


  Future<void> _redeemOfferCodeIfAny(PromoCode? promo) async {
  final code = (promo?.offerId ?? '').trim();
  if (code.isEmpty) return; // nothing to do

  try {
    await Clipboard.setData(ClipboardData(text: code)); // optional UX
    debugPrint('[IAP][iOS] Offer code copied to clipboard: $code');

    final sk = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await sk.presentCodeRedemptionSheet();
    debugPrint('[IAP][iOS] Offer Code Redemption sheet shown');
  } catch (e) {
    // Non-fatal – continue with normal purchase
    debugPrint('[IAP][iOS] Redemption sheet not available/failed: $e');
  }
}

  /// StoreKit-only: If you increased price for an auto-renewable sub,
  /// Apple may require user consent. This only shows if needed.
  Future<void> _maybeShowPriceConsent() async {
    try {
      final sk = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await sk.showPriceConsentIfNeeded();
      debugPrint('[IAP][iOS] Price consent sheet handled (if needed)');
    } catch (e) {
      debugPrint('[IAP][iOS] Price consent check failed (non-fatal): $e');
    }
  }

  /// StoreKit-only: Offer Code redemption UI (closest parity to Android promo offer).
  Future<void> _maybeShowRedemptionSheet() async {
    try {
      final sk = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await sk.presentCodeRedemptionSheet();
      debugPrint('[IAP][iOS] Offer Code Redemption sheet shown');
    } catch (e) {
      debugPrint('[IAP][iOS] Redemption sheet not available/failed (non-fatal): $e');
    }
  }

  

  @override
  Future<void> init() async {
    debugPrint('[IAP][iOS] init() called');
    if (!Platform.isIOS) {
      await _sendError('Not iOS platform');
      return;
    }

    final available = await _iap.isAvailable();
    debugPrint('[IAP][iOS] isAvailable: $available');
    if (!available) {
      await _sendError('App Store not available on this device/account');
      return;
    }

    // Listen to purchases
    // _sub = _iap.purchaseStream.listen(
    //   _onPurchaseUpdate,
    //   onError: (e, st) async {
    //     debugPrint('[IAP][iOS] purchaseStream error: $e');
    //     await _sendError(e.toString(), error: e, st: st);
    //   },
    // );

    // Safe to call; it shows only if required
    //await _maybeShowPriceConsent();
  }

  @override
  Future<void> buySubscription(SubscriptionPlan plan, PromoCode? promoCode) async {
    _lastPlan = plan;
    _lastPromoCode = promoCode;

    String productId = promoCode?.offerId ?? plan.iosSku;
    

    debugPrint('[IAP][iOS] buySubscription(${plan.name}) start');

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        throw IapFailure('App Store not available on this device/account', code: 'billing-unavailable');
      }

      // If you distribute Offer Codes, show native redemption UI first (optional)
      //await _redeemOfferCodeIfAny(promoCode);

      // 1) Query product details
      final resp = await _iap.queryProductDetails({ productId }); //plan.iosSku
      debugPrint('[IAP][iOS] query.notFound: ${resp.notFoundIDs}');
      debugPrint('[IAP][iOS] query.error: ${resp.error}');
      if (resp.productDetails.isEmpty) {
        throw IapFailure('Product not found in App Store: ${plan.iosSku}', code: 'product-not-found');
      }
      
            final List<ProductDetails> details =
          resp.productDetails.cast<ProductDetails>();
      final ProductDetails pd = details.firstWhere(
        (p) => p.id == productId ,   // plan.iosSku
        orElse: () => details.first,
      );
      debugPrint(
          '[IAP][iOS] Product → id=${pd.id}, title=${pd.title}, price=${pd.price}, '
          'currency=${pd.currencyCode}, desc=${pd.description}');
      debugPrint('[IAP][iOS] pd.runtimeType = ${pd.runtimeType}');

      // 2) Build params (no offerToken / changeParam on iOS)
      final appUserName = "";   //(await UserPaymentService.appUserName()) ?? '';
      debugPrint('[IAP][iOS][DISCOUNT] appUserName=$appUserName');

      PurchaseParam param;

      //if (pd is AppStoreProduct2Details) {

        // 🔹 StoreKit 2 path (this is what your logs show)
        
        
        // final sk2Promo = await _buildSk2PromotionalOfferIfAny(
        //   pd: pd,
        //   applicationUserName: appUserName,
        //   promo: promoCode,
        // );

        final sk2Promo=null;

        param = Sk2PurchaseParam(
          productDetails: pd,
          applicationUserName: appUserName.isEmpty ? null : appUserName,
          promotionalOffer: sk2Promo,
        );

        debugPrint('[IAP][iOS][SK2] Using Sk2PurchaseParam '
            'with promo=${sk2Promo?.offerId}');
      //} 
      
      // else {
      //   // 🔹 Legacy StoreKit 1 path (older iOS)
      //   if (pd is AppStoreProductDetails) {
      //     final sk = (pd as AppStoreProductDetails).skProduct;
      //     final ids = sk.discounts.map((d) => d.identifier).toList();
      //     debugPrint('[IAP][iOS] SKProduct discounts identifiers = $ids');
      //   }

      //   final discount = await _buildDiscountIfAny(
      //     pd: pd,
      //     applicationUserName: appUserName,
      //     promo: promoCode,
      //   );

      //   param = AppStorePurchaseParam(
      //     productDetails: pd,
      //     applicationUserName: appUserName.isEmpty ? null : appUserName,
      //     discount: discount,
      //   );

      //   debugPrint('[IAP][iOS][SK1] Using AppStorePurchaseParam '
      //       'with discount=${discount?.identifier}');
      // }

      _expectedProductId = plan.iosSku;
      _purchaseFlowActive = true;
      _attachListenerForFlow();

      // 3) Launch purchase (App Store sheet handles switch if in same group)
      await _iap.buyNonConsumable(purchaseParam: param);
      debugPrint('[IAP][iOS] buyNonConsumable dispatched');
      
      //restore when plat is upgrade no promo applied So no need to restore one more time
      if(promoCode==null){
          restorePurchases();
      }

    } catch (e, st) {
      final msg = (e is IapFailure) ? e.message : 'Purchase failed: ${e.toString()}';
      await _sendError(msg, error: e, st: st);
      _purchaseFlowActive = false;
      _expectedProductId = null;
      rethrow;
    }
  }

  /// For a "Restore Purchases" button on iOS (users expect this).
  /// It triggers StoreKit to re-deliver past purchases via purchaseStream (as restored).
  Future<void> restorePurchases() async {
    try {
      _attachListenerForFlow();
      _purchaseFlowActive=true;
      await _iap.restorePurchases();
      _purchaseFlowActive=false;
      _detachListener();
      debugPrint('[IAP][iOS] restorePurchases requested');
    } catch (e, st) {
      await _sendError('Restore failed: $e', error: e, st: st);
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails d) async {
    try {
      debugPrint("[IAP][iOS][HandleSuccess] called status=${d.status} product=${d.productID} pending=${d.pendingCompletePurchase}");
      
      if (d.pendingCompletePurchase) {
        await _iap.completePurchase(d);
        debugPrint('[IAP][iOS] completePurchase done (status=${d.status})');
      }

      // Track locally
      final token = d.verificationData.serverVerificationData; // Apple receipt container
      debugPrint('[IAP][iOS] token → $token');

      _activeSubscriptions[token] = d.productID;
      _isSubscribed = true;

      final entitlement = await BackendSubscriptionApi.verifyWithApple(
        signedTransactionInfo: token,
      );

      if (entitlement == null) {
        await _sendError('Apple verification failed (null entitlement)');
        return;
      }

      debugPrint('[IAP][iOS] entitlement → $entitlement');

      final nowUtc = DateTime.now().toUtc();
      final isExpired = entitlement.expiresAt != null &&
          entitlement.expiresAt!.isBefore(nowUtc);

      if (d.status == PurchaseStatus.restored && isExpired) {
        debugPrint('[IAP][iOS] restored but expired → ignoring');
        return;
      }

      String productId = _lastPromoCode?.offerId ?? _lastPlan!.iosSku;

      if (d.status == PurchaseStatus.restored &&
          //_lastPlan != null &&                            
         ( productId != entitlement.autoRenewProductId)) {  //_lastPlan!.iosSku   //(_lastPlan!.iosSku != d.productID)
        debugPrint(
            '[IAP][iOS][RESTORE BLOCKED] ❌ Ignoring restored transaction '
            'because product mismatch.\n'
            '   → productId:           $productId \n'
            '   → restored productID:        ${d.productID}\n'
            '   → entitlement.autoRenewProductId: ${entitlement.autoRenewProductId}\n'
            '   → Reason: Restored purchase does NOT match the expected auto-renew SKU.\n'
          );
        
        return;
      }

      // final payload = BackendSubscriptionApi.decodeJwtPayload(token);

      // if (payload.isEmpty) {
      //   await _sendError('Invalid or empty Apple JWT payload');
      //   return;
      // }

      // // 🔹 Log decoded info
      // debugPrint('[IAP][iOS] Decoded payload: $payload');

      // final int pMs = payload['purchaseDate'] ?? 0;
      // final int eMs = payload['expiresDate'] ?? 0;

      // // Always parse Apple timestamps as UTC
      // final subscribedAt = DateTime.fromMillisecondsSinceEpoch(pMs, isUtc: true);
      // final expiresAt = DateTime.fromMillisecondsSinceEpoch(eMs, isUtc: true);

      // // Use UTC for comparison
      // final nowUtc = DateTime.now().toUtc();

      // // 🧾 Add detailed logs
      // debugPrint('[IAP][iOS] Timing check → now(UTC): $nowUtc | expiresAt(UTC): $expiresAt');
      // debugPrint('[IAP][iOS] Timing check → now(local): ${nowUtc.toLocal()} | expiresAt(local): ${expiresAt.toLocal()}');

      // // Check expiry correctly in UTC
      // final bool isExpired = expiresAt.isBefore(nowUtc);
      // debugPrint('[IAP][iOS] isExpired? $isExpired  (expiresAt < nowUtc)');
      // // 🔹 NEW: Skip expired restores
      // if (d.status == PurchaseStatus.restored && isExpired ) {
      //   debugPrint('[IAP][iOS] Skipping restore: subscription already expired at $expiresAt');
      //   continue; // ❌ remove or handle differently
      // }
      
      // final entitlement = GoogleSubscriptionEntitlement(
      //   productId: payload['productId'] ?? '',
      //   chargedUnits : (payload['price'] ?? 0) / 1000.0,
      //   chargedCurrencyCode : payload['currency'] ?? '',
      //   subscribedAt : DateTime.fromMillisecondsSinceEpoch(payload['purchaseDate'] ?? 0),
      //   expiresAt: DateTime.fromMillisecondsSinceEpoch(payload['expiresDate'] ?? 0),
      //   status: 'ACTIVE',
      //   isSubscriptionAutoRenew:true,
      //   //environment: payload['environment'] ?? 'Sandbox',
      // );

      final plan = _lastPlan;
      final promo = _lastPromoCode;
      if (plan != null && entitlement != null) {
        await SubscriptionDataHelper.saveSubscriptionToServer(
          entitlement: entitlement,
          plan: plan,
          promo: promo,
          purchaseToken: entitlement.originalTransactionId ?? '',
          orderId: entitlement.transactionId, // StoreKit transaction id if present
          platform: SubscriptionPlatformType.ios,
          oldTokenToMark: null, // Apple auto-switch; no old token
        );

        // Clear only after success path
        _lastPlan = null;
        _lastPromoCode = null;
      } else {
        debugPrint(
          '[IAP][iOS] WARN: plan or entitlement null; ensure buySubscription(plan, promo) used.',
        );
      }

      _msg.add('ok:Subscription active');
    } catch (e, st) {
      final msg = (e is IapFailure)
          ? e.message
          : 'Acknowledge/verify failed: ${e.toString()}';
      await _sendError(msg, error: e, st: st);
    } finally {
      // >>> CHANGE: standard – reset flow after a handled success
      _purchaseFlowActive = false;
      _expectedProductId = null;
      _detachListener();
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> updates) async {
    try {
      for (final d in updates) {
        debugPrint('[IAP][iOS] [${identityHashCode(this)}] status=${d.status} id=${d.purchaseID} pending=${d.pendingCompletePurchase} product=${d.productID}');
        
        final bool isRestoreFromActiveFlow =
            d.status == PurchaseStatus.restored &&
            _purchaseFlowActive;
            //&& _expectedProductId != null
            //&&  d.productID == _expectedProductId;

        debugPrint(
            "[IAP][iOS][RestoreCheck] status=${d.status} "
            "flowActive=$_purchaseFlowActive "
           // "expected=$_expectedProductId "
            //"product=${d.productID} "
            //"result=$isRestoreFromActiveFlow"
          );
        
        switch (d.status) {
          case PurchaseStatus.pending:
            debugPrint('[IAP][iOS] Purchase pending…');
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            if (isRestoreFromActiveFlow) {
              debugPrint(
                '[IAP][iOS] RESTORED from active flow → treating as purchase',
              );
              await _handleSuccessfulPurchase(d);
            } else {
              // Background / old restore → just complete & ignore
              debugPrint(
                '[IAP][iOS] RESTORED (background/old) → complete & ignore',
              );
              try {
                if (d.pendingCompletePurchase) {
                  await _iap.completePurchase(d);
                  debugPrint(
                    '[IAP][iOS] completePurchase done (background restore)',
                  );
                }
              } catch (e, st) {
                await _sendError(
                  'Restore ignore flow failed: ${e.toString()}',
                  error: e,
                  st: st,
                );
              }
              // IMPORTANT: no verifyWithApple, no saveSubscriptionToServer here
            }
            break;

          case PurchaseStatus.canceled:
            if (d.pendingCompletePurchase) {
              await _iap.completePurchase(d);
            }
            _msg.add('info:Purchase cancelled');
            _purchaseFlowActive = false;
            _expectedProductId = null;
            _detachListener(); // [ADD]
            break;

          case PurchaseStatus.error:
            if (d.pendingCompletePurchase) {
              await _iap.completePurchase(d);
            }
            final errMsg = d.error?.message ?? d.error?.toString() ?? 'Unknown purchase error';
            await _sendError(errMsg, error: d.error, st: StackTrace.current);
            _purchaseFlowActive = false;
            _expectedProductId = null;
            _detachListener(); // [ADD]
            break;
        }
      }
    } catch (e, st) {
      final msg = (e is IapFailure) ? e.message : 'Acknowledge/verify failed: ${e.toString()}';
      await _sendError(msg, error: e, st: st);
      _purchaseFlowActive = false;
      _expectedProductId = null;
      _detachListener(); // [ADD]
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

      await SubscriptionDataHelper.updateReasonForCancellation(
          purchaseToken: token,
          cancelReason: cancelReason,
        );

      final uri = IOSSubscriptionPayment.manageSubscriptionsUri;

      debugPrint('[IAP][iOS] Opening Apple Manage Subscriptions page: $uri');

      final ok = await launchUrl(uri,mode: LaunchMode.externalApplication,);

      if (!ok) {
        throw IapFailure(
          'Unable to open Apple subscription management page',
          code: 'open-failed',
        );
      }

      // Optional: push a UI message so your screen can show a Snackbar/toast
      _msg.add('info:Opened Apple Manage Subscriptions page');
    } catch (e, st) {
      final msg = (e is IapFailure)
          ? e.message
          : 'Cancellation redirect failed: ${e.toString()}';
      await _sendError(msg, error: e, st: st);
      rethrow;
    }
  }

  @override
  Future<void> switchSubscription(SubscriptionPlan plan) async {
    // iOS manages upgrades/downgrades if products are in the same subscription group.
    try {
      await buySubscription(plan, null);
    } catch (e, st) {
      await _sendError(e.toString(), error: e, st: st);
    }
  }

  @override
  void dispose() {
    debugPrint('[IAP][iOS] dispose()');
    _sub?.cancel();
    _msg.close();
  }

  // ---- convenience: expose a link to Apple's Manage Subscriptions UI ----
  static Uri get manageSubscriptionsUri =>
      Uri.parse('https://apps.apple.com/account/subscriptions');
}