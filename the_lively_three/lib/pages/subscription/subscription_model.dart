import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ADD:
import 'dart:io';
import 'dart:async';
import '../../payments/payment_service.dart';
import '../../payments/payment_android.dart';
import '../../payments/payment_ios.dart';
import '../../payments/user_subscription_status.dart';
import '../../payments/user_payment.dart';
import '../../payments/promo_code_service.dart';
import 'subscription_helper.dart';
import 'package:flutter/material.dart';             // <-- for BuildContext
import 'package:the_lively_three/l10n/app_localizations.dart';  // <-- for AppLocalizations


const int kStatusActive = 1;

class SubscriptionFeature {
  final int id;
  final String name;
  final String? description;
  final bool isIncluded;
  final int seqNo;

  SubscriptionFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.isIncluded,
    required this.seqNo,
  });

  factory SubscriptionFeature.fromMap(Map<String, dynamic> m) {
    return SubscriptionFeature(
      id: m['id'] as int,
      name: m['feature_name'] as String,
      description: m['description'] as String?,
      isIncluded: (m['is_included'] ?? true) as bool,
      seqNo: (m['seq_no'] ?? 999) as int,
    );
  }
}

class SubscriptionPlan {
  final int id;
  final int originalSubscriptionId;
  final String locale;
  final String name;
  final String androidSku;
  final String iosSku;
  final num price;
  final String currency;
  final int trialDays;
  final List<SubscriptionFeature> features;

  SubscriptionPlan({
    required this.id,
    required this.originalSubscriptionId,
    required this.locale,
    required this.name,
    required this.androidSku,
    required this.iosSku,
    required this.price,
    required this.currency,
    required this.trialDays,
    required this.features,
  });

  factory SubscriptionPlan.fromMap(Map<String, dynamic> m) {
    final feats = (m['subscription_feature'] as List? ?? [])
        .map((e) => SubscriptionFeature.fromMap(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.seqNo.compareTo(b.seqNo));

    return SubscriptionPlan(
      id: m['id'] as int,
      originalSubscriptionId: m['original_subscription_id'] as int,
      locale: m['locale'] as String,
      name: m['name'] as String,
      androidSku: m['android_sku'] as String,
      iosSku: m['ios_sku'] as String,
      price: m['price'] as num,
      currency: m['currency'] as String,
      trialDays: (m['trial_days'] ?? 0) as int,
      features: feats,
    );
  }
}

class SubscriptionModel with ChangeNotifier {
  final _client = Supabase.instance.client;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String? takeError() {
    final e = _error;
    _error = null;   // consume it so it won't re-toast on rebuilds
    return e;
  }

  List<SubscriptionPlan> _plans = [];
  List<SubscriptionPlan> get plans => _plans;

  late final SubscriptionPaymentService _payments;

  StreamSubscription<String>? _msgSub;

  PromoCode? _appliedPromo;
  PromoCode? get appliedPromo => _appliedPromo;

  UserSubscriptionStatus _current = UserSubscriptionStatus.empty;
  UserSubscriptionStatus get current => _current;

  Future<void> _refreshCurrentFromUsers(String locale) async {
    _current = await UserPaymentService.getCurrentSubscriptionFromUsers(locale);

    if (_current.subscriptionId != null) {
      final p = _findPlanById(_current.originalSubscriptionId!);
      if (p != null) {
        _current = UserSubscriptionStatus(
          isSubscribed: _current.isSubscribed,
          subscriptionId: _current.subscriptionId,
          originalSubscriptionId: _current.originalSubscriptionId,
          subscriptionName: p.name, // filled here
          expiresAt: _current.expiresAt,
          status: _current.status,
          isSubscriptionAutoRenew: _current.isSubscriptionAutoRenew,
        );
      }
    }

    debugPrint('[SubModel] _refreshCurrentFromUsers(locale=$locale): '
        'status=${_current.status}, id=${_current.subscriptionId}, '
        'origId=${_current.originalSubscriptionId}, '
        'name=${_current.subscriptionName}, '
        'expires=${_current.expiresAt?.toIso8601String()}, '
        'autoRenew=${_current.isSubscriptionAutoRenew}');

    notifyListeners();
  }

  SubscriptionPlan? _findPlanById(int id) {
    for (final p in _plans) {
      if (p.originalSubscriptionId == id) return p; //p.id == id ||
    }
    return null;
  }

  Future<void> fetchPlansWithFeatures(String locale) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _client
          .from('subscription')
          .select('*, subscription_feature(*)')
          .eq('status', kStatusActive)
          .eq('locale', locale);

      debugPrint('locale $locale kStatusActive $kStatusActive data $data');
      final List raw = (data as List?) ?? [];
      _plans = raw.map((row) => SubscriptionPlan.fromMap(row)).toList();

      debugPrint(
          '[fetchPlansWithFeatures] locale=$locale fetched=${_plans.length}');
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> init(String? userLocale) async {
    final locale = userLocale ?? 'en';
    await fetchPlansWithFeatures(locale);
    await _refreshCurrentFromUsers(locale);
    if (Platform.isAndroid) {
      _payments = AndroidSubscriptionPayment();
    } else if (Platform.isIOS) {
      _payments = IOSSubscriptionPayment();
    } else {
      _error = 'Subscriptions are supported only on Android and iOS.';
      notifyListeners();
      return;
    }

    _msgSub = _payments.messages.listen((msg) async {
      if (msg.startsWith('error:')) {
        _error = msg.substring(6);
        notifyListeners();
      } else if (msg.startsWith('ok:')) {
        await _refreshCurrentFromUsers(locale);
      }
    });

    await _payments.init();
  }

  Future<void> buySubscription(
      SubscriptionPlan plan, PromoCode? promoCode, {required BuildContext context}) async {
    debugPrint('plan=$plan promoCode=$promoCode');
    if (!Platform.isAndroid && !Platform.isIOS) {
      _error = 'Subscriptions are only available on Android and iOS.';
      notifyListeners();
      return;
    }

    // Need to validate promo is valid
    if (promoCode != null) {
      final ok = await isPromoValid(promoCode.promocode, plan, context:context,notifyOnSuccess: false);
      if (!ok) return;
    }

    try {
      await _payments.buySubscription(plan, promoCode);
    } catch (e) {
      debugPrint('[SubModel] buySubscription error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> cancelSubscription(String cancelReason) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      _error =
          'Subscription cancellation is only supported on Android and iOS.';
      notifyListeners();
      return;
    }

    try {
      await _payments.cancelSubscription(cancelReason);
    } catch (e) {
      debugPrint('[SubModel] cancelSubscription error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<UserSubscriptionStatus> refreshCurrent(String locale) async {
    await _refreshCurrentFromUsers(locale);
    return _current;
  }

  Future<void> switchSubscription(SubscriptionPlan plan) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      _error =
          'Subscription cancellation is only supported on Android and iOS.';
      notifyListeners();
      return;
    }

    try {
      await _payments.switchSubscription(plan);
    } catch (e) {
      debugPrint('[SubModel] switchSubscription error: $e');
    } finally {
      notifyListeners();
    }
  }

  // Future<bool> isPromoValid(String code, SubscriptionPlan plan,{bool notifyOnSuccess = true,}) async {
  //   final String platform = Platform.isAndroid
  //       ? SubscriptionPlatform.android
  //       : Platform.isIOS
  //           ? SubscriptionPlatform.ios
  //           : 'unknown';

  //   debugPrint(
  //       '[isPromoValid] platform=$platform code=$code plan=${plan.originalSubscriptionId}');

  //   final promo = await PromoCodeService.fetchActive(
  //     code: code,
  //     platform: platform,
  //     originalSubscriptionId: plan.originalSubscriptionId,
  //   );

  //   if (promo != null) {
  //     _error = null;
  //     _appliedPromo = promo;
  //     debugPrint(
  //         '[Promo] Applied successfully → id=${promo.id}, offerId=${promo.offerId}');
  //     if (notifyOnSuccess) notifyListeners();
  //     return true; 
  //   } 

  //   final err = PromoCodeService.lastError;
  //   switch (err) {
  //     case 'product_mismatch': {
  //       final targetId = PromoCodeService.lastPromoOriginalSubId;
  //       if (targetId != null) {
  //         // 🟢 auto-detect plan name by matching your plan list
  //         final match = _plans.firstWhere(
  //           (p) => p.originalSubscriptionId == targetId,
  //           orElse: () => plan,
  //         );
  //         _error = 'Promo code is valid for the ${match.name}';
  //       } else {
  //         _error = 'Promo code does not apply to this subscription plan';
  //       }
  //       break;
  //     }
  //     case 'invalid':
  //       _error = 'Promo code is invalid';
  //       break;
  //     case 'already_used':
  //       _error = 'Promo code has already been used';
  //       break;
  //     case 'not_started':
  //       _error = 'Promo code is not yet active';
  //       break;
  //     case 'expired':
  //       _error = 'Promo code has expired';
  //       break;
  //     case 'usage_limit_reached':
  //       _error = 'Promo code has reached its usage limit';
  //       break;
  //     default:
  //       _error = 'Invalid or expired promo code';
  //   }
  //   _appliedPromo = null;
  //   debugPrint('[Promo] Rejected → reason=$err');
  //   notifyListeners();
  //   return false;
  // }

  Future<bool> isPromoValid(
  String code,
  SubscriptionPlan plan, {
  required BuildContext context, // ⬅️ needed for localization
  bool notifyOnSuccess = true,
}) async {
    final int platform = Platform.isAndroid
        ? SubscriptionPlatformType.android
        : Platform.isIOS
            ? SubscriptionPlatformType.ios
            : 0 ;

    debugPrint(
        '[isPromoValid] platform=$platform code=$code plan=${plan.originalSubscriptionId}');

    final promo = await PromoCodeService.fetchActive(
      code: code,
      platform: platform,
      originalSubscriptionId: plan.originalSubscriptionId,
    );

    final l10n = AppLocalizations.of(context)!;

    if (promo != null) {
      _error = null;
      _appliedPromo = promo;
      debugPrint(
          '[Promo] Applied successfully → id=${promo.id}, offerId=${promo.offerId}');
      if (notifyOnSuccess) notifyListeners();
      return true;
    }

    final err = PromoCodeService.lastError;
    switch (err) {
      case 'product_mismatch': {
        final targetId = PromoCodeService.lastPromoOriginalSubId;
        if (targetId != null) {
          // auto-detect target plan for message
          final match = _plans.firstWhere(
            (p) => p.originalSubscriptionId == targetId,
            orElse: () => plan,
          );
          // "Promo code is valid for the {planName}"
          _error = l10n.promo_product_mismatch_for_plan(match.name);
        } else {
          // "Promo code does not apply to this subscription plan"
          _error = l10n.promo_not_applicable_to_plan;
        }
        break;
      }

      case 'invalid':
        _error = l10n.promo_invalid; // "Promo code is invalid"
        break;

      case 'already_used':
        _error = l10n.promo_already_used; // "Promo code has already been used"
        break;

      case 'not_started':
        _error = l10n.promo_not_started; // "Promo code is not yet active"
        break;

      case 'expired':
        _error = l10n.promo_expired; // "Promo code has expired"
        break;

      case 'usage_limit_reached':
        _error = l10n.promo_usage_limit_reached; // "Promo code has reached its usage limit"
        break;

      default:
        _error = l10n.promo_invalid_or_expired; // "Invalid or expired promo code"
    }

    _appliedPromo = null;
    debugPrint('[Promo] Rejected → reason=$err');
    notifyListeners();
    return false;
  }


  void resetPromo() {
    _appliedPromo = null;
    _error = null;
    notifyListeners();
  }

  void disposeModel() {
    _msgSub?.cancel();
    if (_payments != null) {
      _payments.dispose();
    }
  }
}
