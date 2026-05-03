class UserSubscriptionStatus {
  final bool isSubscribed;        // computed: now < expiresAt AND has_subscription
  final int? subscriptionId;      // plan id from users table
  final int? originalSubscriptionId; 
  final String? subscriptionName; // model can fill this from _plans
  final DateTime? expiresAt;      // users.subscription_expires_at
  final String? status;           // computed: 'active' / 'expired' / 'none'
  final bool? isSubscriptionAutoRenew;

  const UserSubscriptionStatus({
    required this.isSubscribed,
    this.subscriptionId,
    this.originalSubscriptionId,
    this.subscriptionName,
    this.expiresAt,
    this.status,
    this.isSubscriptionAutoRenew,
  });

  static const empty = UserSubscriptionStatus(isSubscribed: false, status: 'none');
}
