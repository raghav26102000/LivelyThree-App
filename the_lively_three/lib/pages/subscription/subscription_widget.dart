import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:the_lively_three/components/fluid_bg/fluid_bg_widget.dart';
import 'package:the_lively_three/components/fluid_bg/subscription_bg_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/l10n/app_localizations.dart';
import 'package:the_lively_three/pages/cancel_subscription/cancel_subscription_widget.dart';
import 'subscription_model.dart';
import 'subscription_helper.dart' as subHelper;
import '/providers/locale_provider.dart' as locale_provider;
import '/pages/homepage/homepage_widget.dart';
import 'package:the_lively_three/pages/explore/explore_widget.dart';
import 'package:the_lively_three/pages/settings_new/settings_new_widget.dart';
import 'package:the_lively_three/components/personalized_plant_list/personalized_plant_list_widget.dart';

import 'subscription_audit_helper.dart';
import 'subscription_upgrade_actions.dart';

class UpgradeSubscriptionPage extends StatefulWidget {
  static String routeName = 'subscription';
  static String routePath = '/subscription';
  final String onSuccess;
  final String onFailure;
  final String popupSubTitle;
  final String popupTitle;
  final bool openFullPage;
  const UpgradeSubscriptionPage(
      {super.key,
      required this.onSuccess,
      required this.onFailure,
      this.popupTitle = '',
      this.openFullPage = false,
      this.popupSubTitle = ''});

  @override
  _SubscriptionView createState() => _SubscriptionView();
}

class _SubscriptionView extends State<UpgradeSubscriptionPage> {
  Future<void> _audit(String action, {Map<String, dynamic>? extra}) {
    return subscriptionAuditLog(action: action, extra: extra);
  }

  // UI selection
  final _couponController = TextEditingController();
  String selectPlanDuration = 'Yearly';
  Locale? currentLocale;
  bool showingYearlyplan = true;
  // Provide the model (so we can init/dispose cleanly)
  late final SubscriptionModel _model;

  Future<void>? _initFuture;

  String subscribedPlan = '';
  int? discountPct;
  final List<Map<String, dynamic>> features = [
    //{"feature": "Weekly Health Score", "free": true, "pro": true}
  ];

  bool _previouslySubscribed = false;

  @override
  void initState() {
    super.initState();
    _model = SubscriptionModel();
  }

  void _navigateAfterPaymentSuccess() {
    _audit(
      SubscriptionUpgradeActions.navigationSuccess,
      extra: {'target': widget.onSuccess},
    );

    switch (widget.onSuccess) {
      case 'Settings':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SettingsNewPage()),
        );
        break;

      case 'Home':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomepageWidget()),
        );
        break;

      case 'PersonalizedPlantListWidget':
        context.goNamed(PersonalizedPlantListWidget.routeName);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => const PersonalizedPlantListWidget()),
        // );
        break;

      case 'explore':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ExplorePage()),
        );
        break;

      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomepageWidget()),
        );
    }
  }

  void _navigateAfterPaymentFailure() {
    _audit(
      SubscriptionUpgradeActions.navigationFailure,
      extra: {'target': widget.onFailure},
    );
    switch (widget.onFailure) {
      case 'Settings':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SettingsNewPage()),
        );
        break;

      case 'Home':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomepageWidget()),
        );
        break;

      case 'PersonalizedPlantListWidget':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => const PersonalizedPlantListWidget()),
        );
        break;

      case 'explore':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ExplorePage()),
        );
        break;

      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomepageWidget()),
        );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentLocale == null) {
      // run once
      currentLocale = context.read<locale_provider.FFAppState>().locale;
      print('Locale :- $currentLocale');

      _audit(SubscriptionUpgradeActions.screenOpen, extra: {
        'entry_onSuccess': widget.onSuccess,
        'entry_onFailure': widget.onFailure,
      });

      _initFuture = _model.init(currentLocale.toString()).then((_) {
        // choose initial tab from current subscription AFTER data is loaded
        final s = _model.current; // UserSubscriptionStatus

        _previouslySubscribed = s.isSubscribed; // 👈 track initial state
        final initial = (s.isSubscribed == true &&
                s.subscriptionName == subHelper.SubscriptionPlanTitles.monthly)
            ? 'Monthly'
            : 'Yearly';
        if (mounted) {
          setState(() => selectPlanDuration = initial);
        }
      });
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _model.disposeModel();
    super.dispose();
  }

  void _setSelectedPlan(String value) {
    if (selectPlanDuration != value) {
      // Reset promo UI + state
      _model.resetPromo();
      _couponController.clear();

      _audit(SubscriptionUpgradeActions.tabChange, extra: {
        'from': selectPlanDuration,
        'to': value,
      });
    }
    setState(() => selectPlanDuration = value);
  }

  void _setSubscribedPlan(String value) {
    setState(() => subscribedPlan = value);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    // For Settings: return full page scaffold
    print('widget.openedFrom :- ${widget.onSuccess}');
    if (widget.openFullPage) {
      return _buildFullPage(context);
    }
    // For others: return popup dialog
    return _buildPopup(context);
  }

  Widget _buildFullPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffececec),
      resizeToAvoidBottomInset: true,
      extendBody: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            const SubscriptionGradientBackground(),
            ChangeNotifierProvider<SubscriptionModel>.value(
              value: _model,
              child: FutureBuilder<void>(
                future: _initFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildSubscriptionContent(context, isPopup: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopup(BuildContext context) {
    return ChangeNotifierProvider<SubscriptionModel>.value(
      value: _model,
      child: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildSubscriptionContent(context, isPopup: true);
        },
      ),
    );
  }

  Widget _buildPopupBackground() {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 150,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: RadialGradient(
                colors: [
                  Color(0xFFf8f2df).withOpacity(0.3),
                  Color(0xFFf8f2df).withOpacity(0.3),
                  Color(0xFFf8f2df).withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 75,
          child: Container(
            height: 150,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: RadialGradient(
                colors: [
                  Color(0xFFe0eee1).withOpacity(0.3),
                  Color(0xFFe0eee1).withOpacity(0.3),
                  Color(0xFFe0eee1).withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 0,
          child: Container(
            height: 150,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: RadialGradient(
                colors: [
                  Color(0xFFf9ede1).withOpacity(0.3),
                  Color(0xFFf9ede1).withOpacity(0.3),
                  Color(0xFFf9ede1).withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionContent(BuildContext context,
      {required bool isPopup}) {
    final l10n = AppLocalizations.of(context)!;
    final theme = FlutterFlowTheme.of(context);

    return Consumer<SubscriptionModel>(
      builder: (context, model, _) {
        final err = model.takeError();
        if (err != null && err.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err)),
            );
          });
        }

        if (model.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final plans = model.plans;
        final freePlan = subHelper.findPlanByTitle(
            plans, subHelper.SubscriptionPlanTitles.free);
        final yearlyPlan = subHelper.findPlanByTitle(
            plans, subHelper.SubscriptionPlanTitles.yearly);
        final monthlyPlan = subHelper.findPlanByTitle(
            plans, subHelper.SubscriptionPlanTitles.monthly);

        final freeFeatures = subHelper.includedFeatures(freePlan);
        final monthlyFeatures = subHelper.includedFeatures(monthlyPlan);
        final features =
            subHelper.buildFeatureComparisonList(freeFeatures, monthlyFeatures);

        // Current subscription from model
        final currectSubscription = model.current; // UserSubscriptionStatus
        final bool isSubscribed = currectSubscription.isSubscribed;

        //logic when payment refresh it take back to origin
        if (isSubscribed && !_previouslySubscribed && isPopup) {
          _previouslySubscribed = true; // mark as handled
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _navigateAfterPaymentSuccess();
          });
        }

        // Which plan (by id) is the user on?
        final bool isYearlySub = isSubscribed &&
            currectSubscription.subscriptionId == yearlyPlan?.id;
        final bool isMonthlySub = isSubscribed &&
            currectSubscription.subscriptionId == monthlyPlan?.id;

        // (Optional) a safe display name if model already filled it
        final String currectSubscriptionName =
            currectSubscription.subscriptionName ??
                (isYearlySub
                    ? subHelper.SubscriptionPlanTitles.yearly
                    : isMonthlySub
                        ? subHelper.SubscriptionPlanTitles.monthly
                        : 'your plan');

        //SYSTEM KNOWS _setSubscribedPlan();
        if (isYearlySub == true) {
          subscribedPlan = "Yearly";
        } else if (isMonthlySub == true) {
          subscribedPlan = "Monthly";
        }

        subHelper.logSubscriptionUIState(
          s: currectSubscription,
          yearlyPlan: yearlyPlan,
          monthlyPlan: monthlyPlan,
          isSubscribed: isSubscribed,
          isYearlySub: isYearlySub,
          isMonthlySub: isMonthlySub,
        );

        final expDate =
            subHelper.formatReadableDate(currectSubscription.expiresAt);
        final nextBillingDate =
            expDate != null ? l10n.subscription_line_with_date(expDate) : "";

        // helper to format money quickly
        String _fmt(num amt, String cur) => '${amt.toStringAsFixed(2)} $cur';

        final String? yearlyBilledLabel = yearlyPlan != null
            ? l10n.pricing_billed_with_trial(
                _fmt(yearlyPlan.price, yearlyPlan.currency),
                l10n.period_year,
                yearlyPlan.trialDays,
              )
            : null;

        final String? monthlyPriceLabel = monthlyPlan != null
            ? l10n.pricing_billed_with_trial(
                _fmt(monthlyPlan.price, monthlyPlan.currency),
                l10n.period_month,
                monthlyPlan.trialDays,
              )
            : null;

        discountPct = subHelper.calculateDiscountPct(monthlyPlan, yearlyPlan);

        // Different content based on popup mode
        if (isPopup) {
          return _buildPopupContent(
            context,
            l10n: l10n,
            theme: theme,
            yearlyBilledLabel: yearlyBilledLabel,
            monthlyPriceLabel: monthlyPriceLabel,
            model: model,
            yearlyPlan: yearlyPlan,
            monthlyPlan: monthlyPlan,
          );
        } else {
          if (!isSubscribed) {
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: _buildNonSubscribedFullPage(
                context,
                l10n: l10n,
                theme: theme,
                features: features,
                yearlyBilledLabel: yearlyBilledLabel,
                monthlyPriceLabel: monthlyPriceLabel,
                model: model,
                yearlyPlan: yearlyPlan,
                monthlyPlan: monthlyPlan,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: _buildSubscribedFullPage(
                context,
                l10n: l10n,
                theme: theme,
                yearlyBilledLabel: yearlyBilledLabel,
                monthlyPriceLabel: monthlyPriceLabel,
                currectSubscriptionName: currectSubscriptionName,
                nextBillingDate: nextBillingDate,
                currectSubscription: currectSubscription,
                yearlyPlan: yearlyPlan,
                monthlyPlan: monthlyPlan,
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildPopupContent(
    BuildContext context, {
    required AppLocalizations l10n,
    required FlutterFlowTheme theme,
    required String? yearlyBilledLabel,
    required String? monthlyPriceLabel,
    required SubscriptionModel model,
    required dynamic yearlyPlan,
    required dynamic monthlyPlan,
  }) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background blur effect for full screen
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.white54),
          ),
          // Center popup
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFFf8f2df).withOpacity(0.3),
                                Color(0xFFf8f2df).withOpacity(0.3),
                                Color(0xFFf8f2df).withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 75,
                        child: Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFFe0eee1).withOpacity(0.3),
                                Color(0xFFe0eee1).withOpacity(0.3),
                                Color(0xFFe0eee1).withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 0,
                        child: Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFFf9ede1).withOpacity(0.3),
                                Color(0xFFf9ede1).withOpacity(0.3),
                                Color(0xFFf9ede1).withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () =>
                                    _navigateAfterPaymentFailure(), //Navigator.pop(context)
                                child: const Icon(
                                  Icons.close,
                                  size: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget
                                  .popupTitle, //"Know Your Impact. Improve Your Choices.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                height: 1.61,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget
                                  .popupSubTitle, //"To receive personalized suggestions, please subscribe and give permission to data access.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                height: 1.67,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildPlanCard(
                              title: l10n.plan_annual, //"Annual"
                              subtitle: yearlyBilledLabel,
                              isSelected: selectPlanDuration == 'Yearly',
                              onTap: subscribedPlan == ''
                                  ? () => _setSelectedPlan('Yearly')
                                  : null,
                              showHeader: true,
                            ),
                            const SizedBox(height: 12),

                            // Monthly Plan Card
                            _buildPlanCard(
                              title: l10n.plan_monthly, // "Monthly"
                              subtitle: monthlyPriceLabel,
                              isSelected: selectPlanDuration == 'Monthly',
                              onTap: subscribedPlan == ''
                                  ? () => _setSelectedPlan('Monthly')
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            buildCouponBox(
                              controller: _couponController,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  fixedSize: const Size.fromHeight(50),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                                // onPressed: () {
                                //   Navigator.pop(context);
                                // },
                                onPressed: () => _handleSubscriptionPurchase(
                                    context,
                                    model: model,
                                    yearlyPlan: yearlyPlan,
                                    monthlyPlan: monthlyPlan),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonSubscribedFullPage(
    BuildContext context, {
    required AppLocalizations l10n,
    required FlutterFlowTheme theme,
    required List<Map<String, dynamic>> features,
    required String? yearlyBilledLabel,
    required String? monthlyPriceLabel,
    required SubscriptionModel model,
    required dynamic yearlyPlan,
    required dynamic monthlyPlan,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.sizeOf(context).height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 12,
          children: [
            // Close button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.appName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                  ),
                ),
                InkWell(
                  onTap: _navigateAfterPaymentSuccess,
                  child: Icon(Icons.close, color: theme.primaryText),
                )
              ],
            ),
            Text(
              l10n.intro_title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              l10n.intro_subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: (features.length * 35) + 55,
                    decoration: BoxDecoration(
                      color: const Color(0xfff9f9f9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    // Header Row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 12,
                      children: [
                        // empty left for alignment
                        SizedBox(
                          width: 30,
                          child: Text(
                            "Free",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            "Pro",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    // Feature Rows
                    ...features.map((f) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  f["feature"],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 12,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Icon(
                                      f["free"] ? Icons.check : Icons.remove,
                                      color: Colors.purpleAccent,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Icon(
                                      f["pro"] ? Icons.check : Icons.remove,
                                      color: Colors.purpleAccent,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
            // Plans
            Column(
              spacing: 15,
              children: [
                // Yearly card
                _buildPlanCard(
                  title: l10n.plan_annual,
                  subtitle: yearlyBilledLabel,
                  isSelected: selectPlanDuration == 'Yearly',
                  onTap: subscribedPlan == ''
                      ? () => _setSelectedPlan('Yearly')
                      : null,
                  showHeader: true,
                ),
                // Monthly card
                _buildPlanCard(
                  title: l10n.plan_monthly,
                  subtitle: monthlyPriceLabel,
                  isSelected: selectPlanDuration == 'Monthly',
                  onTap: subscribedPlan == ''
                      ? () => _setSelectedPlan('Monthly')
                      : null,
                ),
                const SizedBox(height: 12),

                buildCouponBox(
                  controller: _couponController,
                )
              ],
            ),
            // Continue button
            if (subscribedPlan == '') const SizedBox(height: 12),

            FilledButton(
              onPressed: () => _handleSubscriptionPurchase(context,
                  model: model,
                  yearlyPlan: yearlyPlan,
                  monthlyPlan: monthlyPlan),
              style: FilledButton.styleFrom(
                backgroundColor: theme.primaryText,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              child: Text(
                l10n.continueButton,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            if (subscribedPlan != '')
              FilledButton(
                onPressed: () async {
                  // await context
                  //     .read<SubscriptionModel>()
                  //     .buySubscription(selectedPlan);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.primaryText,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribedFullPage(
    BuildContext context, {
    required AppLocalizations l10n,
    required FlutterFlowTheme theme,
    required String? yearlyBilledLabel,
    required String? monthlyPriceLabel,
    required String currectSubscriptionName,
    required String nextBillingDate,
    required dynamic currectSubscription,
    required dynamic yearlyPlan,
    required dynamic monthlyPlan,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        children: [
          // Close button row
          // Plans
          Column(
            spacing: 60,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.appName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                  InkWell(
                    onTap: _navigateAfterPaymentSuccess,
                    child: Icon(Icons.close, color: theme.primaryText),
                  )
                ],
              ),
              Column(
                spacing: 20,
                children: [
                  Text(
                    l10n.manage_subscription,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildPlanCard(
                    title: l10n.plan_annual,
                    subtitle: yearlyBilledLabel,
                    isSelected: selectPlanDuration == 'Yearly',
                    onTap: () => _setSelectedPlan('Yearly'),
                    showHeader: true,
                    nextBillingDate: currectSubscriptionName ==
                            subHelper.SubscriptionPlanTitles.yearly
                        ? nextBillingDate
                        : '',
                  ),
                  // Monthly card
                  _buildPlanCard(
                    title: l10n.plan_monthly,
                    subtitle: monthlyPriceLabel,
                    isSelected: selectPlanDuration == 'Monthly',
                    nextBillingDate: currectSubscriptionName ==
                            subHelper.SubscriptionPlanTitles.monthly
                        ? nextBillingDate
                        : '',
                    onTap: () {
                      if (subscribedPlan == 'Yearly') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.downgrade_warning),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: 'Manage',
                              onPressed: () {
                                // TODO: open "Manage Subscription" screen/dialog
                              },
                            ),
                          ),
                        );
                        return;
                      }
                      _setSelectedPlan('Monthly');
                    },
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              if ( //currectSubscription.isSubscriptionAutoRenew == true &&
                  selectPlanDuration == 'Yearly' &&
                      currectSubscriptionName ==
                          subHelper.SubscriptionPlanTitles.yearly)
                FilledButton(
                  onPressed: () async {
                    _audit(
                      SubscriptionUpgradeActions.keepPlanTap,
                      extra: {'plan_type': 'Yearly'},
                    );
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomepageWidget()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.primaryText,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: Text(
                    l10n.keep_my_annual_plan,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              if ( //currectSubscription.isSubscriptionAutoRenew == true &&
                  selectPlanDuration == 'Monthly' &&
                      currectSubscriptionName ==
                          subHelper.SubscriptionPlanTitles.monthly)
                FilledButton(
                  onPressed: () async {
                    _audit(
                      SubscriptionUpgradeActions.keepPlanTap,
                      extra: {'plan_type': 'Monthly'},
                    );
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomepageWidget()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.primaryText,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: Text(
                    l10n.keep_my_monthly_plan,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              if ( //currectSubscription.isSubscriptionAutoRenew == true &&
                  selectPlanDuration == 'Yearly' &&
                      currectSubscriptionName ==
                          subHelper.SubscriptionPlanTitles.monthly)
                FilledButton(
                  onPressed: () async {
                    final selectedPlan = selectPlanDuration == 'Yearly'
                        ? yearlyPlan
                        : monthlyPlan;

                    if (selectedPlan == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.planNotAvailable)),
                      );
                      return;
                    }

                    await context
                        .read<SubscriptionModel>()
                        .switchSubscription(selectedPlan);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.primaryText,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: Text(
                    l10n.switch_to_annual_plan,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              if (currectSubscription.isSubscriptionAutoRenew == true)
                FilledButton(
                  onPressed: () async {
                    _audit(SubscriptionUpgradeActions.cancelSubscriptionOpen);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CancelSubscriptionPage(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: Text(
                    l10n.cancel_subscription,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  void _handleContinueAction(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final model = context.read<SubscriptionModel>();

    final latest = await model.refreshCurrent(currentLocale.toString());

    if (latest.isSubscribed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.alreadySubscribed)),
      );
      return;
    }

    final selectedPlan = selectPlanDuration == 'Yearly'
        ? subHelper.findPlanByTitle(
            model.plans, subHelper.SubscriptionPlanTitles.yearly)
        : subHelper.findPlanByTitle(
            model.plans, subHelper.SubscriptionPlanTitles.monthly);

    if (selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.planNotAvailable)),
      );
      return;
    }

    await model.buySubscription(selectedPlan, model.appliedPromo,
        context: context);

    // Close popup after successful subscription
    if (mounted && widget.onSuccess != 'Settings') {
      Navigator.pop(context);
    }
  }

  void _handleSubscriptionPurchase(BuildContext context,
      {required SubscriptionModel model,
      required dynamic yearlyPlan,
      required dynamic monthlyPlan}) async {
    final l10n = AppLocalizations.of(context)!;

    _audit(
      SubscriptionUpgradeActions.purchaseStart,
      extra: {'selected_duration': selectPlanDuration},
    );

    final latest = await model.refreshCurrent(currentLocale.toString());
    // If already subscribed, just show a short message and stop
    if (latest.isSubscribed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.alreadySubscribed)),
      );
      return;
    }

    // pick selected plan by exact name
    final selectedPlan =
        selectPlanDuration == 'Yearly' ? yearlyPlan : monthlyPlan;
    if (selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.planNotAvailable)),
      );
      return;
    }

    await model.buySubscription(selectedPlan, model.appliedPromo,
        context: context);
  }

  Widget _buildPlanCard({
    required String title,
    String? subtitle = '',
    String? nextBillingDate = '',
    required bool isSelected,
    required VoidCallback? onTap,
    bool showHeader = false,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Opacity(
              opacity: isSelected ? 1 : 0.5,
              child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(children: [
                    if (showHeader)
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xfff4c400),
                                Color(0xfff77f00),
                                Color(0xffe63949),
                                Color(0xffc40cd3),
                              ],
                              stops: [0.0, 0.27, 0.61, 1.0],
                              end: Alignment.topLeft,
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Colors.white70,
                                    style: BorderStyle.solid))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .save_percent(discountPct ?? 0),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xfff4c400),
                            Color(0xfff77f00),
                            Color(0xffe63949),
                            Color(0xffc40cd3),
                          ],
                          stops: [0.0, 0.27, 0.61, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.32),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: !showHeader
                            ? BorderRadius.circular(12)
                            : const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (subtitle != '')
                            Text(
                              '$subtitle',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          if (nextBillingDate != '')
                            Text(
                              textAlign: TextAlign.center,
                              '$nextBillingDate',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ])),
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffc40cd3),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.32),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            if (showHeader)
              Positioned(
                left: 11,
                top: 11,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xfff4c400),
                          Color(0xfff77f00),
                          Color(0xffe63949),
                          Color(0xffc40cd3),
                        ],
                        stops: [0.0, 0.27, 0.61, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          width: 1,
                          color: Colors.white70,
                          style: BorderStyle.solid)),
                  child: Text(
                    AppLocalizations.of(context)!.best_deal,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureList(List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildCouponBox({
    required TextEditingController controller,
    String? hintText,
  }) {
    return StatefulBuilder(
      builder: (context, setSB) {
        final l10n = AppLocalizations.of(context)!; // ✅ accessible here
        bool isLoading = false;
        String? localError; // for inline error text

        Future<void> _apply() async {
          final l10n = AppLocalizations.of(context)!;
          final model = context.read<SubscriptionModel>();

          final selectedPlan = selectPlanDuration == 'Yearly'
              ? subHelper.findPlanByTitle(
                  model.plans, subHelper.SubscriptionPlanTitles.yearly)
              : subHelper.findPlanByTitle(
                  model.plans, subHelper.SubscriptionPlanTitles.monthly);

          if (selectedPlan == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.planNotAvailable)),
            );
            return;
          }

          final code = controller.text.trim();
          if (code.isEmpty) {
            setSB(() => localError = l10n.promo_enter_code);
            return;
          }

          setSB(() {
            isLoading = true;
            localError = null;
          });

          await model.isPromoValid(code, selectedPlan,
              context: context); // model sets appliedPromo & error

          if (!context.mounted) return;

          final applied =
              context.read<SubscriptionModel>().appliedPromo != null;
          final err = context.read<SubscriptionModel>().error;

          if (applied && err == null) {
            _audit(
              SubscriptionUpgradeActions.promoApplySuccess,
              extra: {
                'code': code,
                'selected_duration': selectPlanDuration,
              },
            );
            // ✅ success → lock field, change button label, show toast
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(l10n.promo_applied)), //"Promo code applied"
            );
            setSB(() {
              isLoading = false;
              localError = null;
              // keep controller text as-is
            });
          } else {
            _audit(
              SubscriptionUpgradeActions.promoApplyFailure,
              extra: {
                'code': code,
                'selected_duration': selectPlanDuration,
                'error': err,
              },
            );
            // ❌ invalid → clear input, show inline error
            controller.clear();
            setSB(() {
              isLoading = false;
              localError = err;
            });

            // if (localError != null && localError!.isNotEmpty) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text(localError!)),
            //   );
            // }
          }
        }

        // Drive UI from model so state survives rebuilds
        final model = context.watch<SubscriptionModel>();
        final applied = model.appliedPromo != null;

        return Row(
          children: [
            // 🧾 Text field (disabled after success)
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !applied, // ✅ lock when applied
                decoration: InputDecoration(
                  hintText: hintText ?? l10n.enter_coupon_code,
                  errorText:
                      (!applied && localError != null) ? localError : null,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(99),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(99),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  // Small visual cue when applied
                  suffixIcon: applied
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 🟩 Apply / Applied button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: (applied || isLoading) ? null : _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: applied
                      ? Colors.green
                      : FlutterFlowTheme.of(context).primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    if (isLoading) const SizedBox(width: 8),
                    if (!isLoading && applied)
                      const Icon(Icons.check, color: Colors.white),
                    if (!isLoading && applied) const SizedBox(width: 6),
                    Text(
                      isLoading
                          ? "Checking..."
                          : (applied ? l10n.applied : l10n.apply),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
