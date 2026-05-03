import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_lively_three/components/fluid_bg/fluid_bg_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import '/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStatic extends StatefulWidget {
  static const String routeName = 'OnboardingStatic';
  static const String routePath = '/onboarding_static';
  const OnboardingStatic({Key? key}) : super(key: key);

  @override
  State<OnboardingStatic> createState() => _OnboardingStaticState();
}

class _OnboardingStaticState extends State<OnboardingStatic> {
  final PageController _controller = PageController();
  int _index = 0;

  Future<void> _finish() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('onboarding0_seen', true);
    if (!mounted) return;
    context.go('/login'); // change path if your login route differs
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _PageOne(),
      const _PageTwo(),
      _PageThree(onGetStarted: _finish),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            const FluidGradientBackground(),
            // Pager
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),

            // Dots (bottom, always visible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 18 + MediaQuery.of(context).padding.bottom,
              child: _Dots(
                count: pages.length,
                activeIndex: _index,
                onDotTap: (i) => _controller.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- PAGE 1 (unchanged from your first screen) ----------
class _PageOne extends StatelessWidget {
  const _PageOne();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locale.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 28),
                  color: FlutterFlowTheme.of(context).blackText,
                  fontFamily: 'KoHo',
                  fontWeight: FontWeight.w700),
            ),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locale.onBoardingStaticPage1Title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 28),
                      color: Color(0xfff9f9f9),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  locale.onBoardingStaticPage1Desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Color(0xfff9f9f9),
                      height: 1.625,
                      letterSpacing: 0.8),
                ),
              ],
            )
          ],
        ));
  }
}

/// ---------- PAGE 2  ----------
class _PageTwo extends StatelessWidget {
  const _PageTwo();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locale.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 28),
                  color: FlutterFlowTheme.of(context).blackText,
                  fontFamily: 'KoHo',
                  fontWeight: FontWeight.w700),
            ),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locale.onBoardingStaticPage2Title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 28),
                      color: Color(0xfff9f9f9),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  locale.onBoardingStaticPage2Desc1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Color(0xfff9f9f9),
                      height: 1.625,
                      letterSpacing: 0.8),
                ),
                Text(
                  locale.onBoardingStaticPage2Desc2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Color(0xfff9f9f9),
                      height: 1.625,
                      letterSpacing: 0.8),
                ),
              ],
            )
          ],
        ));
  }
}

/// ---------- PAGE 2 (your new design + "Let's Get Started!") ----------
class _PageThree extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _PageThree({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locale.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 28),
                  color: FlutterFlowTheme.of(context).blackText,
                  fontFamily: 'KoHo',
                  fontWeight: FontWeight.w700),
            ),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locale.onBoardingStaticPage3Title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 28),
                      color: Color(0xfff9f9f9),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  locale.onBoardingStaticPage3Desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      color: Color(0xfff9f9f9),
                      height: 1.625,
                      letterSpacing: 0.8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        locale.letsGetStarted,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: FlutterFlowTheme.adjustScale(size: 14),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

/// ---------- Shared widgets ----------
class _Dots extends StatelessWidget {
  final int count;
  final int activeIndex;
  final ValueChanged<int>? onDotTap;

  const _Dots({
    required this.count,
    required this.activeIndex,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(count, (i) {
        final bool isActive = i == activeIndex;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onDotTap == null ? null : () => onDotTap!(i),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.black : Colors.transparent,
              border: !isActive
                  ? Border.all(color: Colors.black.withOpacity(0.3), width: 1)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
