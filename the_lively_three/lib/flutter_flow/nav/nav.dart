import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lively_three/components/personalized_plant_list/detailed_recipe_widget.dart';
import 'package:the_lively_three/components/personalized_plant_list/personalized_plant_list_widget.dart';
import 'package:the_lively_three/pages/cancel_subscription/cancel_subscription_widget.dart';
import 'package:the_lively_three/pages/delete_account/delete_account_widget.dart';
import 'package:the_lively_three/pages/fiber_explore/fiber_explore_widget.dart';
import 'package:the_lively_three/pages/low_micronutrients/low_micronutrients_widget.dart';
import 'package:the_lively_three/pages/onboarding/onboarding_static_widget.dart';
import 'package:the_lively_three/pages/settings_new/settings_new_widget.dart';
import 'package:the_lively_three/pages/sign_up_otp/sign_up_otp_widget.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/onboarding/onboarding_get_started_widget.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? HomepageWidget() : LoginWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? HomepageWidget() : LoginWidget(),
        ),
        FFRoute(
          name: LoginWidget.routeName,
          path: LoginWidget.routePath,
          builder: (context, params) => LoginWidget(
            preferredTabIndex: params.getParam(
              'preferredTabIndex',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: SettingsWidget.routeName,
          path: SettingsWidget.routePath,
          requireAuth: true,
          builder: (context, params) => SettingsWidget(
            settingsTabObjective: params.getParam(
              'settingsTabObjective',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: PlantselectionWidget.routeName,
          path: PlantselectionWidget.routePath,
          requireAuth: true,
          builder: (context, params) {
            final dietarySource =
                params.getParam('dietarySource', ParamType.int);
            print(
                '🌱 Route builder: dietarySource=$dietarySource'); // This is the debug print you see

            return PlantselectionWidget(
              dietarySource: dietarySource ?? 1, // Provide default value
            );
          },
        ),
        FFRoute(
          name: DashboardWidget.routeName,
          path: DashboardWidget.routePath,
          requireAuth: true,
          builder: (context, params) => DashboardWidget(),
        ),
        FFRoute(
          name: BodyWidget.routeName,
          path: BodyWidget.routePath,
          requireAuth: true,
          builder: (context, params) => BodyWidget(),
        ),
        FFRoute(
          name: MoodWidget.routeName,
          path: MoodWidget.routePath,
          requireAuth: true,
          builder: (context, params) => MoodWidget(),
        ),
        FFRoute(
          name: AdministrationWidget.routeName,
          path: AdministrationWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AdministrationWidget(),
        ),
        FFRoute(
          name: NutrientdetailsWidget.routeName,
          path: NutrientdetailsWidget.routePath,
          requireAuth: true,
          builder: (context, params) => NutrientdetailsWidget(
            blueprintindex: params.getParam(
              'blueprintindex',
              ParamType.int,
            ),
            blueprintlabel: params.getParam(
              'blueprintlabel',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PortionchangeWidget.routeName,
          path: PortionchangeWidget.routePath,
          requireAuth: true,
          builder: (context, params) => PortionchangeWidget(
            idLoc: params.getParam(
              'idLoc',
              ParamType.int,
            ),
            plantname: params.getParam(
              'plantname',
              ParamType.String,
            ),
            color: params.getParam(
              'color',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: HomepageWidget.routeName,
          path: HomepageWidget.routePath,
          requireAuth: true,
          builder: (context, params) => HomepageWidget(),
        ),
        FFRoute(
          name: AddonsWidget.routeName,
          path: AddonsWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AddonsWidget(),
        ),
        FFRoute(
          name: TempWidget.routeName,
          path: TempWidget.routePath,
          builder: (context, params) => TempWidget(),
        ),
        FFRoute(
          name: MeterWidget.routeName,
          path: MeterWidget.routePath,
          requireAuth: true,
          builder: (context, params) => MeterWidget(),
        ),
        FFRoute(
          name: SignupCheckWidget.routeName,
          path: SignupCheckWidget.routePath,
          builder: (context, params) => SignupCheckWidget(
            emailaddress: params.getParam(
              'emailaddress',
              ParamType.String,
            ),
            password: params.getParam(
              'password',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PasswordForgottenWidget.routeName,
          path: PasswordForgottenWidget.routePath,
          builder: (context, params) => PasswordForgottenWidget(),
        ),
        FFRoute(
          name: PasswordPinCheckWidget.routeName,
          path: PasswordPinCheckWidget.routePath,
          builder: (context, params) => PasswordPinCheckWidget(
            emailaddress: params.getParam(
              'emailaddress',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PasswordResetWidget.routeName,
          path: PasswordResetWidget.routePath,
          builder: (context, params) => PasswordResetWidget(
            emailaddress: params.getParam(
              'emailaddress',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: OnboardingGetStartedWidget.routeName,
          path: OnboardingGetStartedWidget.routePath,
          builder: (context, params) => const OnboardingGetStartedWidget(),
        ),
        FFRoute(
          name: ProgressPage.routeName,
          path: ProgressPage.routePath,
          builder: (context, params) => const ProgressPage(),
        ),
        FFRoute(
          name: ConsistencyPage.routeName,
          path: ConsistencyPage.routePath,
          builder: (context, params) {
            final title =
                (params.getParam('title', ParamType.String) as String?) ??
                    'Consistency';
            return ConsistencyPage(title: title);
          },
        ),
        FFRoute(
          name: TodayConsumptionWidget.routeName,
          path: TodayConsumptionWidget.routePath,
          builder: (context, params) => const TodayConsumptionWidget(),
        ),
        FFRoute(
          name: PlantProfileWidget.routeName,
          path: PlantProfileWidget.routePath,
          builder: (context, params) {
            final userId = params.getParam<String>('userId', ParamType.String);
            final primaryColor =
                params.getParam<String>('primaryColor', ParamType.String);
            final categoryIcon =
                params.getParam<String>('categoryIcon', ParamType.String);
            final locId = params.getParam<int>('locId', ParamType.int);
            final week = params.getParam<int>('week', ParamType.int);
            final year = params.getParam<int>('year', ParamType.int);

            debugPrint(
                "🌱 Route builder: userId=$userId, locId=$locId, week=$week, year=$year");

            return PlantProfileWidget(
              userId: userId ?? '',
              locId: locId ?? 0,
              week: week ?? 0,
              year: year ?? 0,
              categoryIcon: categoryIcon ?? '',
              primaryColor: primaryColor,
            );
          },
        ),
        FFRoute(
          name: BottomDetailedPage.routeName,
          path: BottomDetailedPage.routePath,
          builder: (context, params) => const BottomDetailedPage(),
        ),
        FFRoute(
          name: OtherConsumptionWidget.routeName,
          path: OtherConsumptionWidget.routePath,
          builder: (context, params) => const OtherConsumptionWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => const SignUpWidget(),
        ),
        FFRoute(
          name: SignUpOtpWidget.routeName,
          path: SignUpOtpWidget.routePath,
          builder: (context, params) => const SignUpOtpWidget(),
        ),
        FFRoute(
          name: ExplorePage.routeName,
          path: ExplorePage.routePath,
          builder: (context, params) => const ExplorePage(),
        ),
        FFRoute(
          name: UpgradeSubscriptionPage.routeName,
          path: UpgradeSubscriptionPage.routePath,
          builder: (context, params) {
            final openFrom =
                params.getParam<String>('openedFrom', ParamType.String);
            final popupTitle =
                params.getParam<String>('popupTitle', ParamType.String);
            final popupSubTitle =
                params.getParam<String>('popupSubTitle', ParamType.String);
            return UpgradeSubscriptionPage(
                onSuccess: openFrom,
                onFailure: openFrom,
                popupTitle: popupTitle,
                popupSubTitle: popupSubTitle);
          },
        ),
        FFRoute(
          name: DetailedRecipeWidget.routeName,
          path: DetailedRecipeWidget.routePath,
          builder: (context, params) {
            final recipeName =
                params.getParam<String>('recipeName', ParamType.String);
            return DetailedRecipeWidget(
              recipeName: recipeName,
            );
          },
        ),
        FFRoute(
          name: UserInfoPage.routeName,
          path: UserInfoPage.routePath,
          builder: (context, params) => const UserInfoPage(),
        ),
        FFRoute(
          name: OnboardingStatic.routeName,
          path: OnboardingStatic.routePath,
          builder: (context, params) => const OnboardingStatic(),
        ),
        FFRoute(
          name: SettingsNewPage.routeName,
          path: SettingsNewPage.routePath,
          builder: (context, params) => const SettingsNewPage(),
        ),
        FFRoute(
          name: PersonalizedPlantListWidget.routeName,
          path: PersonalizedPlantListWidget.routePath,
          builder: (context, params) => const PersonalizedPlantListWidget(),
        ),
        FFRoute(
          name: DeleteAccountPage.routeName,
          path: DeleteAccountPage.routePath,
          builder: (context, params) => const DeleteAccountPage(),
        ),
        FFRoute(
          name: FiberExplorePage.routeName,
          path: FiberExplorePage.routePath,
          builder: (context, params) {
            final exploreType =
                params.getParam<String>('exploreType', ParamType.String);
            return FiberExplorePage(exploreType: exploreType);
          },
        ),
        FFRoute(
          name: LowMicronutrientsPage.routeName,
          path: LowMicronutrientsPage.routePath,
          builder: (context, params) {
            final exploreType =
                params.getParam<String>('exploreType', ParamType.String);
            return LowMicronutrientsPage(exploreType: exploreType);
          },
        ),
        FFRoute(
          name: CancelSubscriptionPage.routeName,
          path: CancelSubscriptionPage.routePath,
          builder: (context, params) => const CancelSubscriptionPage(),
        ),
        FFRoute(
          name: OnboardingWidget.routeName,
          path: OnboardingWidget.routePath,
          builder: (context, params) => OnboardingWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/login';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Color(0xFFFAF8F5),
                  child: Center(
                    child: Image.asset(
                      'assets/images/TLT_-_Website_Logo_III.png',
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
