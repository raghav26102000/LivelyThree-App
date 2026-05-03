import 'dart:async';
import '../pages/subscription/subscription_model.dart';
import 'promo_code_service.dart';

abstract class SubscriptionPaymentService {
  Future<void> init();
  Future<void> buySubscription(SubscriptionPlan plan, PromoCode? promoCode);
  Future<void> cancelSubscription(String cancelReason);
  Future<void> switchSubscription(SubscriptionPlan plan);
  void dispose();
  Stream<String> get messages; // emits “error” text for UI snackbars
}
