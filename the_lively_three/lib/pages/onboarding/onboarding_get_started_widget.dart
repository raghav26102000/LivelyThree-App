import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/l10n/app_localizations.dart';

/// Onboarding flow with swipe + dots.
/// Page 1 = your original lettuce/grapefruit screen
/// Page 2 = new "Fiber up, feel good." screen (specs applied)
class OnboardingGetStartedWidget extends StatefulWidget {
  static const String routeName = 'OnboardingGetStarted';
  static const String routePath = '/onboarding_get_started';
  const OnboardingGetStartedWidget({Key? key}) : super(key: key);

  @override
  State<OnboardingGetStartedWidget> createState() =>
      _OnboardingGetStartedWidgetState();
}

class _OnboardingGetStartedWidgetState
    extends State<OnboardingGetStartedWidget> {
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
      _PageTwo(onGetStarted: _finish),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // Pager
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => pages[i],
            ),

            // Skip (top-right)
            // Positioned(
            //   right: 16,
            //   top: MediaQuery.of(context).padding.top + 8,
            //   child: TextButton(
            //     onPressed: _finish,
            //     child: const Text(
            //       'Skip',
            //       style: TextStyle(
            //         fontFamily: 'Montserrat',
            //         fontWeight: FontWeight.w600,
            //         fontSize: 14,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),

            // Dots (bottom, always visible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
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

  // Update to match your actual filenames
  static const String lettuce = 'assets/images/lettuce.png';
  static const String orange = 'assets/images/orange.png';
  static const String logo = 'assets/images/LOGO.png';

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Stack(
      children: [
        // Lettuce background (rotated, positioned top-left)
        Positioned(
          right: -MediaQuery.of(context).size.width * 0.18,
          bottom: MediaQuery.of(context).size.height * 0.4,
          child: Transform.rotate(
            angle: 0, // deg -> rad
            child: Image.asset(
              lettuce,
              width: MediaQuery.of(context).size.width * 1.89,
              height: MediaQuery.of(context).size.height * 0.85,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Orange/Grapefruit (bottom-right)
        Positioned(
          right: -MediaQuery.of(context).size.width * 0.071,
          bottom: MediaQuery.of(context).size.height * 0.25,
          child: Image.asset(
            orange,
            width: MediaQuery.of(context).size.width * 0.69,
            height: MediaQuery.of(context).size.height * 0.28,
            fit: BoxFit.contain,
          ),
        ),

        // Logo on lettuce
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.135, // keep your vertical offset
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              logo,
              width: MediaQuery.of(context).size.width * 0.41,
              height: MediaQuery.of(context).size.height * 0.21,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Text block
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                locale.trackByColor,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.043,
                  height: 1.25,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                locale.discoverFoodImpact,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.030,
                  height: 20 / 12, // 20px line-height
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 96), // space for dots overlay
          ],
        ),
      ],
    );
  }
}

/// ---------- PAGE 2 (your new design + "Let's Get Started!") ----------
class _PageTwo extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _PageTwo({required this.onGetStarted});

  // Update to match your actual filenames
  static const String greens = 'assets/images/green_bokchoy.png';
  static const String melon = 'assets/images/yellow_melon.png';
  static const String logo = 'assets/images/LOGO.png';

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Stack(
      children: [
        // Melon slices (pos 138.48, 331.74, size 259x259)
        Positioned(
          right: MediaQuery.of(context).size.width * 0.0179,
          top: MediaQuery.of(context).size.height * 0.392,
          child: Image.asset(
            melon,
            width: MediaQuery.of(context).size.width * 0.66,
            height: MediaQuery.of(context).size.height * 0.308,
            fit: BoxFit.contain,
          ),
        ),
        // Big greens (rotate 7°, pos -99.57, -56.02, size 460x538)
        Positioned(
          left: -MediaQuery.of(context).size.width * 0.256,
          top: -MediaQuery.of(context).size.height * 0.066,
          child: Transform.rotate(
            angle: 7 * 3.1415926535 / 180,
            child: Image.asset(
              greens,
              width: MediaQuery.of(context).size.width * 1.34,
              height: MediaQuery.of(context).size.height * 0.701,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Logo (reuse page1 placement/size; adjust if your file needs different)
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.135, // keep your vertical offset
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              logo,
              width: MediaQuery.of(context).size.width * 0.41,
              height: MediaQuery.of(context).size.height * 0.21,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Text + CTA
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                locale.fiberUp,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width *
                      0.043, // close to mock; change to 18 if you need smaller
                  height: 1.25,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                locale.dailyPortionSupport,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // small text spec you provided for page 2:
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.030,
                  height: 20 / 12, // 20px line-height
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // "Let's Get Started!" CTA
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
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 64), // space for dots overlay
          ],
        ),
      ],
    );
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
