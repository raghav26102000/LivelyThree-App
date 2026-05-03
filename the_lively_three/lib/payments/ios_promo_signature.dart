class IosPromoSignature {
  /// App Store Connect key ID (the "Key ID" of your In-App Purchase key)
  final String keyIdentifier;

  /// Base64 ES256 signature returned by the backend
  final String signature;

  final String nonce;

  final int timestampMs;

  IosPromoSignature({
    required this.keyIdentifier,
    required this.signature,
    required this.nonce,
    required this.timestampMs,
  });

  factory IosPromoSignature.fromJson(Map<String, dynamic> json) {
    return IosPromoSignature(
      keyIdentifier: json['keyIdentifier'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
      nonce: json['nonce'] as String? ?? '',
      timestampMs: (json['timestamp'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyIdentifier': keyIdentifier,
      'signature': signature,
      'nonce': nonce,
      'timestamp': timestampMs,
    };
  }
}
