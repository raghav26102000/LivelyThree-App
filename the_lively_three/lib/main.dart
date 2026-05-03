import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_lively_three/pages/onboarding/onboarding_static_widget.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';

import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import '/l10n/app_localizations.dart';
import '/providers/locale_provider.dart' as locale_provider;
import '/custom_code/actions/setup_notification.dart' as Notifications;
import 'package:flutter/services.dart';

// // 👇 import your renamed onboarding file
// import 'pages/onboarding/onboarding_get_started_widget.dart';

/// 🔀 Route paths used for first-run routing.
const String kOnboarding0Route =
    '/onboarding_static'; // use the routePath from your widget
const String kLoginRoute = '/login';
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ⭐ Enable edge-to-edge system UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();
  await Notifications.initNotifications();
  await SupaFlow.initialize();
  await FlutterFlowTheme.initialize();

  // ✅ Read persisted first-run flag *before* building the app.
  final prefs = await SharedPreferences.getInstance();
  final currentSession = SupaFlow.client.auth.currentSession;
  if (currentSession == null) {
    print("🚫 No active session detected — resetting onboarding flag");
    //await prefs.remove('onboarding0_seen');
  }
  final hasSeenOnboarding0 = prefs.getBool('onboarding0_seen') ?? false;
  print("🔍 main(): onboarding0_seen flag = $hasSeenOnboarding0");

  final appState = FFAppState();
  await appState.initializePersistedState();
  final localeAppState = locale_provider
      .FFAppState(); // Using FFAppState from locale_provider.dart (with prefix)
  await localeAppState.initializePersistedState();

  runApp(
    ChangeNotifierProvider<FFAppState>(
      create: (context) =>
          appState, // Provide FFAppState globally for the entire app
      child: ChangeNotifierProvider<locale_provider.FFAppState>(
        create: (context) =>
            localeAppState, // Provide LocaleAppState for locale management
        child: MyApp(
            hasSeenOnboarding0: hasSeenOnboarding0), // Your root widget (MyApp)
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool hasSeenOnboarding0;
  const MyApp({super.key, required this.hasSeenOnboarding0});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  // Locale _locale = const Locale('en');
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late Stream<BaseAuthUser> userStream;

  // Prevent double first-run routing.
  bool _firstRunRouteHandled = false;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // 🔁 FIRST-RUN DECISION:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          "🚨 initState(): widget.hasSeenOnboarding0 = ${widget.hasSeenOnboarding0}");
      if (!_firstRunRouteHandled && !widget.hasSeenOnboarding0) {
        _firstRunRouteHandled = true;
        print("➡️ First launch detected → Navigating to $kOnboarding0Route");
        _router.go(kOnboarding0Route);
      } else {
        print("✅ Onboarding already seen → continue normal flow");
      }
    });

    // ✅ Central place to handle Supabase auth events
    SupaFlow.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;
      print(
          "📡 Supabase auth event = $event, session = $session, otpFlag = $suppressAuthNavigation");

      if (suppressAuthNavigation) {
        print("⚠️ Auth navigation suppressed (OTP flow)");
        return;
      }

      if ((event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.initialSession) &&
          session != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding0_seen', true);
        print("🎉 onboarding0_seen set TRUE after login");

        print("✅ User active: ${session.user.email}");

        try {
          print("🔄 Calling upsertUser…");
          final onboarded = await authManager.upsertUser();
          print("✅ upsertUser returned: $onboarded");

          // ✅ Route safely using the router itself (no disposed context)
          final route =
              onboarded ? HomepageWidget.routePath : OnboardingWidget.routePath;
          print("🔀 Navigating to $route");
          _router.go(route);
        } catch (e, st) {
          print("❌ upsertUser failed: $e\n$st");
        }
      } else {
        print("ℹ️ Supabase event $event with no active session");
      }
    });

    userStream = theLivelyThreeSupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  String getRoute() {
    try {
      final routeMatch = _router.routerDelegate.currentConfiguration.last;
      final matchList = routeMatch is ImperativeRouteMatch
          ? routeMatch.matches
          : _router.routerDelegate.currentConfiguration;
      return matchList.uri.toString();
    } catch (_) {
      return '';
    }
  }

  List<String> getRouteStack() {
    try {
      return _router.routerDelegate.currentConfiguration.matches.map((m) {
        final matchList = m is ImperativeRouteMatch
            ? m.matches
            : _router.routerDelegate.currentConfiguration;
        return matchList.uri.toString();
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<locale_provider.FFAppState>(
      builder: (context, localeAppState, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: localeAppState.locale, // Use locale from FFAppState
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('de'),
            Locale('nl'),
          ],
          title: 'The Lively Three',
          scrollBehavior: MyAppScrollBehavior(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          localeListResolutionCallback: (deviceLocales, supported) {
            print("📱 Device preferred locales: $deviceLocales");

            // Get the first device locale
            final deviceLocale = deviceLocales?.first;
            if (deviceLocale != null) {
              print("🔍 Checking device locale: ${deviceLocale.languageCode}");

              // Find the matching locale by language code only
              final match = supported.firstWhere(
                (s) => s.languageCode == deviceLocale.languageCode,
                orElse: () => const Locale('en'),
              );

              // Only update if the locale has changed
              if (localeAppState.locale?.languageCode != match.languageCode) {
                print("✅ Updating app locale to: ${match.languageCode}");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  localeAppState.setLocale(match);
                });
              }

              return match;
            }

            // Fallback to English if no device locale found
            print("⚠️ No device locale found. Falling back to English.");
            if (localeAppState.locale?.languageCode != 'en') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                localeAppState.setLocale(const Locale('en'));
              });
            }
            return const Locale('en');
          },
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: false,
            fontFamily: 'Montserrat',
          ),
          darkTheme: ThemeData(
            fontFamily: 'Montserrat',
            brightness: Brightness.dark,
            useMaterial3: false,
          ),
          themeMode: _themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}
