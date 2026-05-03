import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../payments/payment_service.dart';
import '../../payments/payment_android.dart';
import '../../payments/payment_ios.dart';

class CancelSubscriptionModel extends ChangeNotifier {
  // === VARIABLES ===
  final SupabaseClient _client = Supabase.instance.client;
  SubscriptionPaymentService? _payments;

  bool _isLoading = false;
  bool _isCancelling = false;
  String? _error;
  List<Map<String, dynamic>> _cancelReasons = [];

  // === GETTERS ===
  bool get isLoading => _isLoading;
  bool get isCancelling => _isCancelling;
  String? get error => _error;
  List<Map<String, dynamic>> get cancelReasons => _cancelReasons;

  // === CONSTRUCTOR ===
  CancelSubscriptionModel();

  // === INIT (call from didChangeDependencies) ===
  Future<void> init(String locale) async {
    // ✅ Initialize the correct payment service
    if (Platform.isAndroid) {
      _payments = AndroidSubscriptionPayment();
    }else if (Platform.isIOS) {
      _payments = IOSSubscriptionPayment();
    } else {
      // You can implement iOS later
      _payments = null;
      debugPrint('[CancelModel] iOS not implemented yet');
    }

    // Load cancel reasons
    await loadCancelReasons(locale);
  }

  // === LOAD CANCEL REASONS ===
  Future<void> loadCancelReasons(String locale) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    // ✅ updated query for your table structure
    final data = await _client
        .from('codelkup')
        .select('keycode, key1')
        .eq('lkcode', 'cancel_subscription_reason')
        .eq('key2', locale )
        .order('keycode', ascending: true);

    _cancelReasons = (data as List)
        .map((e) => {
              'keycode': e['keycode'] ?? '',
              'display_name': e['key1'] ?? '', // what we show in UI
            })
        .toList();

    debugPrint('[CancelModel] Loaded ${_cancelReasons.length} reasons');
  } catch (e, st) {
    _error = e.toString();
    debugPrint('[CancelModel] loadCancelReasons error: $e\n$st');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

String _reasonTextFromCode(int code) {
  for (final m in _cancelReasons) {
    final c = (m['keycode'] as int?) ?? int.tryParse('${m['keycode']}');
    if (c == code) {
      return (m['display_name'] ?? '').toString();
    }
  }
  // fallback if not found
  return code.toString();
}

  // === CANCEL SUBSCRIPTION ===
  Future<void> cancelSubscription(int cancelReasonCode) async {
  if (_payments == null) {
    _error = 'Payment service not initialized. Call init(locale) first.';
    notifyListeners();
    return;
  }

  _isCancelling = true;
  _error = null;
  notifyListeners();

  try {
    // map code -> text
    final reasonText = _reasonTextFromCode(cancelReasonCode);
    debugPrint('[CancelModel] Cancelling with code: $cancelReasonCode -> "$reasonText"');

    // send TEXT to payments (backend will store the string)
    await _payments!.cancelSubscription(reasonText);

    debugPrint('[CancelModel] Cancellation complete');
  } catch (e, st) {
    _error = e.toString();
    debugPrint('[CancelModel] cancelSubscription error: $e\n$st');
  } finally {
    _isCancelling = false;
    notifyListeners();
  }
}
}