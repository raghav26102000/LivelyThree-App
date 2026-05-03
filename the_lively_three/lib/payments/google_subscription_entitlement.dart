class GoogleSubscriptionEntitlement {
  final String status;          // "active", "expired", etc.
  final DateTime? subscribedAt;      // normalized.start_at
  final DateTime? expiresAt;    // normalized.expires_at
  final String? productId;      // normalized.product_id
  final bool? isSubscriptionAutoRenew;
  final String? chargedCurrencyCode; // e.g. "INR"
  final double? chargedUnits;        // e.g. 100.0
  final String? taxCurrencyCode;     // e.g. "INR"
  final bool? isTaxInclusive;           // normalized.auto_renew

  final String? originalTransactionId; 
  final String? transactionId;
  final String? autoRenewProductId;

  const GoogleSubscriptionEntitlement({
    required this.status,
    this.subscribedAt,
    this.expiresAt,
    this.productId,
    this.isSubscriptionAutoRenew,
    this.chargedCurrencyCode,
    this.chargedUnits,
    this.taxCurrencyCode,
    this.isTaxInclusive,
    this.originalTransactionId,
    this.transactionId,
    this.autoRenewProductId,
  });

  factory GoogleSubscriptionEntitlement.fromNormalized(Map j) {
    DateTime? parseIso(Object? v) {
      if (v is String && v.isNotEmpty) {
        try { return DateTime.parse(v); } catch (_) {}
      }
      return null;
    }

    final chargedAmount = j['charged_amount'] as Map?;
    final chargedTax = j['charged_tax'] as Map?;

    return GoogleSubscriptionEntitlement(
      status   : (j['status'] as String?) ?? 'unknown',
      subscribedAt  : parseIso(j['subscribed_at']),
      expiresAt: parseIso(j['expires_at']),
      productId: j['product_id'] as String?,                 
      isSubscriptionAutoRenew: j['isSubscriptionAutoRenew'] as bool?,
      chargedCurrencyCode: chargedAmount?['currencyCode'] as String?,
      chargedUnits: chargedAmount?['units'] != null
          ? double.tryParse(chargedAmount!['units'].toString())
          : null,
      taxCurrencyCode: chargedTax?['currencyCode'] as String?,
      isTaxInclusive: j['is_tax_inclusive'] as bool?,
    
      // 🔥 Read new fields from backend-normalized map
      originalTransactionId: j['originalTransactionId'] as String?,
      transactionId: j['transactionId'] as String?,
      autoRenewProductId: j['autoRenewProductId'] as String?,

    );
  }

@override
  String toString() {
    return '''
        GoogleSubscriptionEntitlement {
          status: $status,
          subscribedAt: $subscribedAt,
          expiresAt: $expiresAt,
          productId: $productId,
          isSubscriptionAutoRenew: $isSubscriptionAutoRenew,
          chargedUnits: $chargedUnits,
          chargedCurrencyCode: $chargedCurrencyCode,
          taxCurrencyCode: $taxCurrencyCode,
          isTaxInclusive: $isTaxInclusive,
          originalTransactionId: $originalTransactionId,
          transactionId: $transactionId,
          autoRenewProductId: $autoRenewProductId
        }
     ''';
  }
}
