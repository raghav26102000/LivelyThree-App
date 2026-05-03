/// Used to keep analytics + audit logging consistent across the app.
class SubscriptionUpgradeActions {
  // ✔ Screen lifecycle
  static const screenOpen = 'screen_open';

  // ✔ UI interactions
  static const tabChange = 'tab_change';
  static const buttonTap = 'button_tap';

  // ✔ Promo code flow
  static const promoApplyTap = 'promo_apply_tap';
  static const promoApplySuccess = 'promo_apply_success';
  static const promoApplyFailure = 'promo_apply_failure';

  // ✔ Purchase flow – BEFORE SDK is triggered
  static const purchaseStart = 'purchase_start';
  static const purchaseBlockedAlreadySubscribed =
      'purchase_blocked_already_subscribed';
  static const purchasePlanNotAvailable = 'purchase_plan_not_available';

  // ✔ Purchase flow – AFTER SDK is triggered
  static const purchaseTriggered = 'purchase_triggered';

  // ✔ Navigation events
  static const navigationSuccess = 'navigation_success';
  static const navigationFailure = 'navigation_failure';

  // ✔ Plan management
  static const keepPlanTap = 'keep_plan_tap';
  static const switchPlanTap = 'switch_plan_tap';

  // ✔ Related screens
  static const cancelSubscriptionOpen = 'cancel_subscription_open';
}
