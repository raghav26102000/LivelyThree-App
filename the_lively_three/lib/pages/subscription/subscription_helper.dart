// lib/pages/subscription/subscription_helper.dart
import 'package:flutter/foundation.dart';
import '../../payments/user_subscription_status.dart';
import 'subscription_model.dart';
import 'package:intl/intl.dart';


class SubscriptionKeywords {
  static String year = 'year';
  static String month = 'month';
}

class SubscriptionPlanTitles {
  static const String free  = 'Free Plan';
  static const String yearly  = 'Annual Plan';
  static const String monthly = 'Monthly Plan';
}

class SubscriptionPlatform {
  //static const String android  = 'android';
  //static const String ios = 'ios';
}

class SubscriptionPlatformType {
  static const int android  = 1;
  static const int ios = 2 ;
}

/// Returns a provisional expiry based on plan name.
/// "year"  -> +365 days, "month" -> +30 days. Otherwise null.
DateTime? computeExpiryFromName(
  String name, {
  DateTime? baseUtc,
  int monthlyDays = 30,
  int yearlyDays = 365,
}) {
  final n = name.toLowerCase();
  final now = (baseUtc ?? DateTime.now()).toUtc();
  if (n.contains(SubscriptionKeywords.year)) return now.add(Duration(days: yearlyDays));
  if (n.contains(SubscriptionKeywords.month)) return now.add(Duration(days: monthlyDays));
  return null;
}

int? subscriptionDaysFromName(
  String name, {
  int monthlyDays = 30,
  int yearlyDays = 365,
}) {
  final n = name.toLowerCase();

  // Prefer your existing keywords if defined
  final hasYear  = n.contains(SubscriptionKeywords.year)  || n.contains('year')  || n.contains('annual');
  final hasMonth = n.contains(SubscriptionKeywords.month) || n.contains('month') || n.contains('mo');

  if (hasYear)  return yearlyDays;
  if (hasMonth) return monthlyDays;
  return null;
}

/// Back-compat alias if other files still call the old name.
DateTime? guessExpiryFromName(
  String name, {
  DateTime? baseUtc,
  int monthlyDays = 30,
  int yearlyDays = 365,
}) =>
    computeExpiryFromName(
      name,
      baseUtc: baseUtc,
      monthlyDays: monthlyDays,
      yearlyDays: yearlyDays,
    );

/// Find a plan by exact title (case-insensitive), with a soft contains fallback.
SubscriptionPlan? findPlanByTitle(List<SubscriptionPlan> plans, String title) {
  final t = title.toLowerCase().trim();
  for (final p in plans) {
    if (p.name.toLowerCase().trim() == t) return p; // exact
  }
  for (final p in plans) {
    if (p.name.toLowerCase().contains(t)) return p; // soft
  }
  return null;
}

/// Return only included feature names (non-empty, trimmed).
// List<String> includedFeatures(SubscriptionPlan? plan) {
//   if (plan == null) return const [];
//   return plan.features
//       .where((f) => f.isIncluded)
//       .map((f) => f.name.trim())
//       .where((s) => s.isNotEmpty)
//       .toList();
// }


List<Map<String, dynamic>> includedFeatures(SubscriptionPlan? plan) {
  if (plan == null) return const [];

  final sorted = [...plan.features];
  sorted.sort((a, b) => (a.seqNo ?? 999).compareTo(b.seqNo ?? 999));

  // Map only valid (non-null) names
  return sorted
      .where((f) => f.isIncluded && (f.name?.trim().isNotEmpty ?? false)) // ✅ null-safe check
      .map((f) => {
            "name": f.name!.trim(),
            "seqNo": f.seqNo ?? 999,
          })
      .toList();
}

List<Map<String, dynamic>> buildFeatureComparisonList(
    List<Map<String, dynamic>> freeFeatures,
    List<Map<String, dynamic>> proFeatures) {

  // Combine all unique features (by name)
  final Map<String, Map<String, dynamic>> combined = {};

  // Add free plan features
  for (var f in freeFeatures) {
    combined[f["name"]] = {
      "feature": f["name"],
      "seqNo": f["seqNo"],
      "free": true,
      "pro": false,
    };
  }

  // Add pro plan features
  for (var f in proFeatures) {
    if (combined.containsKey(f["name"])) {
      combined[f["name"]]!["pro"] = true;
    } else {
      combined[f["name"]] = {
        "feature": f["name"],
        "seqNo": f["seqNo"],
        "free": false,
        "pro": true,
      };
    }
  }

  // Convert map to list and sort by seqNo
  final result = combined.values.toList();
  result.sort((a, b) => (a["seqNo"] ?? 999).compareTo(b["seqNo"] ?? 999));

  return result;
}




/// Format a DateTime to YYYY-MM-DD (local time). Returns null if dt is null.
String? yyyyMmDd(DateTime? dt) {
  if (dt == null) return null;
  final local = dt.toLocal();
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String? formatReadableDate(DateTime? dt) {
  if (dt == null) return null;
  final local = dt.toLocal();
  final formatter = DateFormat('MMMM dd, yyyy · hh:mm a'); // DateFormat('MMMM dd, yyyy'); // MonthName DD, YYYY
  return formatter.format(local);
}

/// Centralized UI logging for quick diagnostics.
void logSubscriptionUIState({
  required UserSubscriptionStatus s,
  required SubscriptionPlan? yearlyPlan,
  required SubscriptionPlan? monthlyPlan,
  required bool isSubscribed,
  required bool isYearlySub,
  required bool isMonthlySub,
}) {
  debugPrint('[sub][ui] current='
      'isSubscribed=${s.isSubscribed}, '
      'id=${s.subscriptionId}, '
      'name=${s.subscriptionName}, '
      'expiresAt=${s.expiresAt}, '
      'status=${s.status}');
  debugPrint('[sub][ui] plans='
      'yearlyId=${yearlyPlan?.id}(${yearlyPlan?.name}), '
      'monthlyId=${monthlyPlan?.id}(${monthlyPlan?.name})');
  debugPrint('[sub][ui] matches='
      'isYearlySub=$isYearlySub, '
      'isMonthlySub=$isMonthlySub');
}

int? calculateDiscountPct(SubscriptionPlan? monthlyPlan, SubscriptionPlan? yearlyPlan) {
  if (yearlyPlan != null &&
      monthlyPlan != null &&
      monthlyPlan.price > 0) {
    final monthlyAnnual = monthlyPlan.price * 12;
    final raw = ((monthlyAnnual - yearlyPlan.price) / monthlyAnnual) * 100;
    final rounded = raw.round(); // use .floor() if you prefer
    if (rounded > 0) {
      return rounded; // only show if a real discount
    }
  }
  return null;
}


















// int? discountPct;
//           if (yearlyPlan != null &&
//               monthlyPlan != null &&
//               monthlyPlan.price > 0) {
//             final monthlyAnnual = monthlyPlan.price * 12;
//             final raw =
//                 ((monthlyAnnual - yearlyPlan.price) / monthlyAnnual) * 100;
//             final rounded = raw.round(); // or .floor() if you prefer
//             if (rounded > 0)
//               discountPct = rounded; // only show if a real discount
//           }

// final statusKey = s.status == 'expired' ? 'expired' : 'expires';
          // final subLine = expDate != null
          //     ? l10n.subscription_line_with_date(
          //         currectSubscriptionName, // plan
          //         statusKey, // "expired" | "expires"
          //         expDate, // date string
          //       )
          //     : l10n.subscription_line_no_date(currectSubscriptionName);