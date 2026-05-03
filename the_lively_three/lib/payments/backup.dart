// @override
//   Future<void> revalidateSubscription() async {
//   try {
//     final token = await UserPaymentService.getLatestPurchaseTokenForCurrentUser();
//     if (token == null) return;
//     GoogleSubscriptionEntitlement? subscriptionEntitlement = await _verifyWithBackend(token: token);
//     debugPrint('subscriptionEntitlement -  $subscriptionEntitlement');
//     if(subscriptionEntitlement!=null && subscriptionEntitlement.isSubscriptionAutoRenew==false){
//        //applyAutoRenewCancellation(token);
//     }
//   } catch (e) {
//     debugPrint('[IAP] revalidateSubscription error: $e');
//   }
// }

// void applyAutoRenewCancellation(String token)async {
//    await UserPaymentService.applyAutoRenewCancellation(
//       purchaseToken: token,
//       subscriptionStatus: 'cancelled'
//     );
//     debugPrint('done applyAutoRenewCancellation token $token');
// }

//   Future<void> _restoreOwnedSubscriptions() async {
//   try {
//     _activeSubscriptions.clear();
//     _isSubscribed = false;

//     await _iap.restorePurchases();                      // triggers _onPurchaseUpdate
//     await Future.delayed(const Duration(seconds: 2));   // give it a moment

//     debugPrint('[IAP][Android] restore: '
//         '${_activeSubscriptions.length} owned → ${_activeSubscriptions.values.toList()}');

//     if (_activeSubscriptions.isEmpty) {
//       _msg.add('info:No active subscription');
//     } else {
//       _isSubscribed = true;
//       _msg.add('info:Active subscription(s) found');
//     }
//   } catch (e) {
//     debugPrint('[IAP][Android] Error during restore: $e');
//   }
// }



// static Future<bool> applyAutoRenewCancellation({
//   required String purchaseToken,
//   String subscriptionStatus = 'cancelled',
//   DateTime? expiresAt,
//   String? latestOrderId,
// }) async {
//   try {
//     final client = Supabase.instance.client;
//     final user   = client.auth.currentUser;
//     if (user == null) {
//       debugPrint('[user_payment] cancel: no logged-in user');
//       return false;
//     }

//     // Build update for user_payment
//     final update = <String, dynamic>{
//       'subscription_status': subscriptionStatus,                          // e.g. "cancelled"
//       'isSubscriptionAutoRenew': false,          // turn off flag
//       'updated_at': DateTime.now().toUtc().toIso8601String(),
//       if (expiresAt != null)  'expires_at':  expiresAt.toUtc().toIso8601String(),
//       if (latestOrderId != null) 'order_id': latestOrderId,
//     };

//     // 1) Update user_payment by purchase_token
//     final payRes = await client
//         .from('user_payment')
//         .update(update)
//         .eq('purchase_token', purchaseToken)
//         .select('id')
//         .maybeSingle();

//     final ok = payRes != null;
//     debugPrint('[user_payment] cancel update ${ok ? "OK" : "NO ROW"} token=$purchaseToken payload=$update');

//     // 2) Mirror the auto-renew flag to users (best-effort)
//     if (ok) {
//       try {
//         await client
//             .from('users')
//             .update({'isSubscriptionAutoRenew': false})
//             .eq('id', user.id);
//       } catch (e) {
//         debugPrint('[user_payment] users mirror (autoRenew=false) failed: $e');
//       }
//     }

//     return ok;
//   } catch (e) {
//     debugPrint('[user_payment] cancel error: $e');
//     return false;
//   }
// }



// 1) Compute plan duration from this purchase (expiresAt - subscribedAt)
        // Duration? planDuration;
        // if (subscribedAt != null && expiresAt != null) {
        //   final diff = expiresAt.toUtc().difference(subscribedAt.toUtc());
        //   if (!diff.isNegative && diff.inSeconds > 0) {
        //     planDuration = diff;
        //   }
        // }

        //DateTime? computedExpiry;

        // 2) If we have a valid duration, stack it on top of the user's current expiry
        //if (planDuration != null) {
          // try {
          //   final prevRow = await Supabase.instance.client
          //       .from('users')
          //       .select('subscription_expires_at')
          //       .eq('id', user.id)
          //       .maybeSingle();

          //   final prevStr = prevRow?['subscription_expires_at'] as String?;
          //   final prevExp = prevStr != null ? DateTime.parse(prevStr).toUtc() : null;

          //   final nowUtc = DateTime.now().toUtc();
          //   // If previous expiry is in the past, base = now; otherwise base = previous expiry
          //   final base = (prevExp != null && prevExp.isAfter(nowUtc)) ? prevExp : nowUtc;

          //   //final int? days = subHelper.subscriptionDaysFromName(subscriptionName); //Run if part
          //   final int? days = 0; //Plateform difference -- Run else part
          //   if (days != null && days > 0) {
          //     final planDuration = Duration(days: days); // or Duration(seconds: days * 24 * 3600)
          //     computedExpiry = base.toUtc().add(planDuration);
          //   }else{
          //     computedExpiry = base.add(planDuration);
          //   }


          //   debugPrint('[user_payment] stacked expiry: prev=$prevExp base=$base + dur=${planDuration.inSeconds}s => $computedExpiry');
          // } catch (e) {
          //   debugPrint('[user_payment] read prev expiry failed: $e');
          // }
        //}



  //       @override
  // Future<void> switchSubscription(SubscriptionPlan plan) async {
  // try {
    
    
  //   //need to call swith it take base plan only not least price one 
  //   buySubscription(plan,null);
    
    
    // debugPrint('[IAP][Switch] start → targetSku=${plan.androidSku}');

    // // 0) Billing availability
    // final available = await _iap.isAvailable();
    // if (!available) {
    //   _msg.add('error:Play Billing not available on this device/account');
    //   debugPrint('[IAP][Switch] abort: billing not available');
    //   return;
    // }

    // // 1) Load target product details
    // final resp = await _iap.queryProductDetails({plan.androidSku});
    // debugPrint('[IAP][Switch] query: notFound=${resp.notFoundIDs} error=${resp.error}');
    // if (resp.productDetails.isEmpty) {
    //   _msg.add('error:Product not found in Play: ${plan.androidSku}');
    //   return;
    // }
    // final pd = resp.productDetails.first;

    // // 2) Offer token + (optional) pricing phase info
    // String? offerToken;
    
    // if (pd is GooglePlayProductDetails) {
    //   final offers = pd.productDetails.subscriptionOfferDetails;
    //   if (offers != null && offers.isNotEmpty) {
    //     final o = offers.first;
    //     offerToken = o.offerIdToken;

    //     final phases = o.pricingPhases;
    //     if (phases.isNotEmpty) {
    //       final p0 = phases.first;
    //     }
    //     debugPrint('[IAP][Switch] offer basePlanId=${o.basePlanId} token=$offerToken');
    //   }
    // }

    // // 3) Find an existing (different) owned subscription to switch FROM
    // final oldPurchase = await _findOldPurchaseForSwitch(targetSku: plan.androidSku);

    // // If none found (e.g., first purchase on device), just do a normal buy
    // if (oldPurchase == null) {
    //   debugPrint('[IAP][Switch] no old purchase → fallback to buySubscription');
    //   //_lastPlan = plan; // make sure _onPurchaseUpdate can persist the right plan
    //   //await buySubscription(plan);
    //   return;
    // }

    // _switchingFromToken = oldPurchase.verificationData.serverVerificationData;

    // // 4) Build change params with proration (Google handles unused time credit)
    // final changeParam = ChangeSubscriptionParam(
    //   oldPurchaseDetails: oldPurchase,
    //   replacementMode: ReplacementMode.withTimeProration
    // );
    // debugPrint('[IAP][Switch] using changeSubscription (immediateWithTimeProration)');

    // // 5) Dispatch the switch
    // _lastPlan = plan; // so _onPurchaseUpdate → insertPayment() uses this plan
    
    // String? appUserName=await UserPaymentService.appUserName();
    // debugPrint('appUserName $appUserName');
    // final gpParam = GooglePlayPurchaseParam(
    //   productDetails: pd,
    //   offerToken: offerToken,
    //   changeSubscriptionParam: changeParam,
    //   applicationUserName: appUserName?? "", 
    // );

    // await _iap.buyNonConsumable(purchaseParam: gpParam);
    // debugPrint('[IAP][Switch] dispatched change request');

    // Play’s UI handles pricing/credits. Your _onPurchaseUpdate + _verifyWithBackend
    // will deliver the new entitlement (productId, subscribedAt, expiresAt, autoRenew).
//   } catch (e) {
//     debugPrint('[IAP] switchSubscription error: $e');
//     _msg.add('error:$e');
//   }
// }


//Subscription model
// Future<void> reVerifySubscription() async {
  //   if (!Platform.isAndroid) {
  //     _error = 'iOS payment not implemented yet';
  //     notifyListeners();
  //     return;
  //   }
  //   _payments = AndroidSubscriptionPayment();
  //   await _payments.revalidateSubscription();
  // }



        
      // final gpds = byId.values.toList();

      // final GooglePlayProductDetails pd = gpds.firstWhere(
      //   (d) => d.id == plan.androidSku,
      //   orElse: () => gpds.first,
      // );

