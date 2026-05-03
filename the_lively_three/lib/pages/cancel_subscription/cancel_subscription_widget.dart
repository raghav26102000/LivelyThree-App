// cancel_subscription_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lively_three/components/fluid_bg/fluid_bg_widget.dart';
import 'package:the_lively_three/components/fluid_bg/subscription_bg_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/l10n/app_localizations.dart';
import 'package:the_lively_three/pages/cancel_subscription/cancel_subscription_model.dart';
import '/providers/locale_provider.dart' as locale_provider;
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';
import '/pages/homepage/homepage_widget.dart';

class CancelSubscriptionPage extends StatefulWidget {
  static String routeName = 'cancel-subscription';
  static String routePath = '/cancel-subscription';
  const CancelSubscriptionPage({super.key});

  @override
  _SubscriptionView createState() => _SubscriptionView();
}

class _SubscriptionView extends State<CancelSubscriptionPage> {
  late CancelSubscriptionModel _model;
  Locale? currentLocale;

  int? _currentValue;
  late var cancelingConfirmationScreen = false;

  @override
  void initState() {
    super.initState();
    _model = CancelSubscriptionModel();

    _model.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentLocale == null) {
      // run once
      currentLocale = context.read<locale_provider.FFAppState>().locale;
      print('Locale :- $currentLocale');
      _model.init(currentLocale.toString());
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _setCurrentScreen(bool value) {
    setState(() => cancelingConfirmationScreen = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffececec),
      body: SafeArea(
        child: Stack(
          children: [
            const SubscriptionGradientBackground(),
            if (!cancelingConfirmationScreen)
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 12,
                  children: [
                    Column(
                      spacing: 40,
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
                              onTap: () => Navigator.pop(context),
                              child:
                                  Icon(Icons.close, color: theme.primaryText),
                            )
                          ],
                        ),
                        Column(
                          spacing: 20,
                          children: [
                            Text(
                              l10n.cancel_title,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            _buildRadioButtonList(),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        FilledButton(
                          onPressed: () {
                            _setCurrentScreen(true);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.primaryText,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width - 40,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          child: Text(
                            l10n.continueButton,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            if (cancelingConfirmationScreen)
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 12,
                  children: [
                    Column(
                      spacing: 40,
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
                              onTap: () => Navigator.pop(context),
                              child:
                                  Icon(Icons.close, color: theme.primaryText),
                            )
                          ],
                        ),
                       Column(
                          spacing: 16,
                          children: [
                            Text(
                              l10n.cancel_confirm_title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l10n.cancel_confirm_subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                height: 1.563,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed:
                              _model.isCancelling ? null : _onConfirmCancel,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.5 - 24,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          child: Text(
                            l10n.cancel_subscription,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const HomepageWidget()),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.primaryText,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.5 - 24,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          child: Text(
                            l10n.keep_subscription,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButtonList() {
    // Loading state
    final l10n = AppLocalizations.of(context)!;

    if (_model.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (_model.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          _model.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    // Empty state
    if (_model.cancelReasons.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(l10n.no_cancel_reasons),
      );
    }

    // List of reasons
    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // avoid nested scroll issues
      itemCount: _model.cancelReasons.length,
      itemBuilder: (context, index) {
        final reason = _model.cancelReasons[index];
        final int value = (reason['keycode'] as int?) ??
            int.parse(reason['keycode'].toString());
        final String title = (reason['display_name'] ?? '').toString();

        return RadioListTile<int>(
          title: Text(title),
          value: value,
          groupValue: _currentValue,
          activeColor: FlutterFlowTheme.of(context).primaryText,
          onChanged: (val) => setState(() => _currentValue = val),
        );
      },
    );
  }

  Future<void> _onConfirmCancel() async {

    final l10n = AppLocalizations.of(context)!;

    if (_currentValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(l10n.must_select_reason)),
      );
      setState(() => cancelingConfirmationScreen = false);
      return;
    }

    await _model.cancelSubscription(_currentValue!);

    if (!mounted) return;

    if (_model.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cancel failed: ${_model.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subscription_cancelled)),
      );
      Navigator.of(context).pop(true);

      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomepageWidget()),
                    );
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (_) => const UpgradeSubscriptionPage(
      //             openedFrom: 'Settings',
      //           )),
      // );
    }
  }
}
