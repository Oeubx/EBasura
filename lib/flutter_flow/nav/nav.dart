import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

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
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? PageHomepageWidget()
          : LandingPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? PageHomepageWidget()
              : LandingPageWidget(),
        ),
        FFRoute(
          name: PageHomepageWidget.routeName,
          path: PageHomepageWidget.routePath,
          builder: (context, params) => PageHomepageWidget(),
        ),
        FFRoute(
          name: PImagesViewAllWidget.routeName,
          path: PImagesViewAllWidget.routePath,
          builder: (context, params) => PImagesViewAllWidget(),
        ),
        FFRoute(
          name: PageUserManagementWidget.routeName,
          path: PageUserManagementWidget.routePath,
          builder: (context, params) => PageUserManagementWidget(),
        ),
        FFRoute(
          name: PReportViewOneWidget.routeName,
          path: PReportViewOneWidget.routePath,
          builder: (context, params) => PReportViewOneWidget(
            reportRef: params.getParam<ReportRow>(
              'reportRef',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: PReportViewAllWidget.routeName,
          path: PReportViewAllWidget.routePath,
          builder: (context, params) => PReportViewAllWidget(),
        ),
        FFRoute(
          name: PageAdminDashboardWidget.routeName,
          path: PageAdminDashboardWidget.routePath,
          builder: (context, params) => PageAdminDashboardWidget(),
        ),
        FFRoute(
          name: PDatesViewOneWidget.routeName,
          path: PDatesViewOneWidget.routePath,
          builder: (context, params) => PDatesViewOneWidget(
            collectionRef: params.getParam<CollectionRow>(
              'collectionRef',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: PageProfileWidget.routeName,
          path: PageProfileWidget.routePath,
          builder: (context, params) => PageProfileWidget(),
        ),
        FFRoute(
          name: LandingPageWidget.routeName,
          path: LandingPageWidget.routePath,
          builder: (context, params) => LandingPageWidget(),
        ),
        FFRoute(
          name: PageSignUpWidget.routeName,
          path: PageSignUpWidget.routePath,
          builder: (context, params) => PageSignUpWidget(),
        ),
        FFRoute(
          name: PageSignInWidget.routeName,
          path: PageSignInWidget.routePath,
          builder: (context, params) => PageSignInWidget(),
        ),
        FFRoute(
          name: TermsAndConditionsWidget.routeName,
          path: TermsAndConditionsWidget.routePath,
          builder: (context, params) => TermsAndConditionsWidget(),
        ),
        FFRoute(
          name: PageForgotPasswordWidget.routeName,
          path: PageForgotPasswordWidget.routePath,
          builder: (context, params) => PageForgotPasswordWidget(),
        ),
        FFRoute(
          name: PImagesViewAllUserWidget.routeName,
          path: PImagesViewAllUserWidget.routePath,
          builder: (context, params) => PImagesViewAllUserWidget(),
        ),
        FFRoute(
          name: PageLeaderboardWidget.routeName,
          path: PageLeaderboardWidget.routePath,
          builder: (context, params) => PageLeaderboardWidget(),
        ),
        FFRoute(
          name: PageViewSubFeaturesWidget.routeName,
          path: PageViewSubFeaturesWidget.routePath,
          builder: (context, params) => PageViewSubFeaturesWidget(),
        ),
        FFRoute(
          name: PStreetViewOneWidget.routeName,
          path: PStreetViewOneWidget.routePath,
          builder: (context, params) => PStreetViewOneWidget(
            streetsRef: params.getParam<StreetRow>(
              'streetsRef',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: PageVerifyEmailWidget.routeName,
          path: PageVerifyEmailWidget.routePath,
          builder: (context, params) => PageVerifyEmailWidget(
            userEmail: params.getParam(
              'userEmail',
              ParamType.String,
            ),
            userPassword: params.getParam(
              'userPassword',
              ParamType.String,
            ),
            userConfirmPassword: params.getParam(
              'userConfirmPassword',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PageProfileSettingsWidget.routeName,
          path: PageProfileSettingsWidget.routePath,
          builder: (context, params) => PageProfileSettingsWidget(),
        ),
        FFRoute(
          name: PageChangePasswordWidget.routeName,
          path: PageChangePasswordWidget.routePath,
          builder: (context, params) => PageChangePasswordWidget(),
        ),
        FFRoute(
          name: PageChangeEmailWidget.routeName,
          path: PageChangeEmailWidget.routePath,
          builder: (context, params) => PageChangeEmailWidget(),
        ),
        FFRoute(
          name: PImgUploadResearchWidget.routeName,
          path: PImgUploadResearchWidget.routePath,
          builder: (context, params) => PImgUploadResearchWidget(),
        ),
        FFRoute(
          name: PageChangeProfileWidget.routeName,
          path: PageChangeProfileWidget.routePath,
          builder: (context, params) => PageChangeProfileWidget(),
        ),
        FFRoute(
          name: PageProfileAboutWidget.routeName,
          path: PageProfileAboutWidget.routePath,
          builder: (context, params) => PageProfileAboutWidget(),
        ),
        FFRoute(
          name: PImgViewVerifierWidget.routeName,
          path: PImgViewVerifierWidget.routePath,
          builder: (context, params) => PImgViewVerifierWidget(
            imageIDref: params.getParam<ImageRow>(
              'imageIDref',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: PDatesViewAllWidget.routeName,
          path: PDatesViewAllWidget.routePath,
          builder: (context, params) => PDatesViewAllWidget(),
        ),
        FFRoute(
          name: PStreetViewAllWidget.routeName,
          path: PStreetViewAllWidget.routePath,
          builder: (context, params) => PStreetViewAllWidget(),
        ),
        FFRoute(
          name: PBadgeViewAllWidget.routeName,
          path: PBadgeViewAllWidget.routePath,
          builder: (context, params) => PBadgeViewAllWidget(),
        ),
        FFRoute(
          name: PBadgeViewOneWidget.routeName,
          path: PBadgeViewOneWidget.routePath,
          builder: (context, params) => PBadgeViewOneWidget(
            badgeRef: params.getParam<BadgeRow>(
              'badgeRef',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: PageProfileAboutResearchWidget.routeName,
          path: PageProfileAboutResearchWidget.routePath,
          builder: (context, params) => PageProfileAboutResearchWidget(),
        ),
        FFRoute(
          name: PageProfileAboutADETWidget.routeName,
          path: PageProfileAboutADETWidget.routePath,
          builder: (context, params) => PageProfileAboutADETWidget(),
        ),
        FFRoute(
          name: PImgUploadAAuthWidget.routeName,
          path: PImgUploadAAuthWidget.routePath,
          builder: (context, params) => PImgUploadAAuthWidget(),
        ),
        FFRoute(
          name: PImgUploadAGuestWidget.routeName,
          path: PImgUploadAGuestWidget.routePath,
          builder: (context, params) => PImgUploadAGuestWidget(),
        ),
        FFRoute(
          name: PageFilteredImagesWidget.routeName,
          path: PageFilteredImagesWidget.routePath,
          builder: (context, params) => PageFilteredImagesWidget(),
        ),
        FFRoute(
          name: PImagesViewAllAiWidget.routeName,
          path: PImagesViewAllAiWidget.routePath,
          builder: (context, params) => PImagesViewAllAiWidget(),
        ),
        FFRoute(
          name: PImagesViewAllUncategorizedWidget.routeName,
          path: PImagesViewAllUncategorizedWidget.routePath,
          builder: (context, params) => PImagesViewAllUncategorizedWidget(),
        ),
        FFRoute(
          name: PImagesViewAllUnsegregatedWidget.routeName,
          path: PImagesViewAllUnsegregatedWidget.routePath,
          builder: (context, params) => PImagesViewAllUnsegregatedWidget(),
        ),
        FFRoute(
          name: PImagesViewAllSegregatedWidget.routeName,
          path: PImagesViewAllSegregatedWidget.routePath,
          builder: (context, params) => PImagesViewAllSegregatedWidget(),
        ),
        FFRoute(
          name: PImagesViewAllFlaggedWidget.routeName,
          path: PImagesViewAllFlaggedWidget.routePath,
          builder: (context, params) => PImagesViewAllFlaggedWidget(),
        ),
        FFRoute(
          name: PImagesViewAllVerifiedWidget.routeName,
          path: PImagesViewAllVerifiedWidget.routePath,
          builder: (context, params) => PImagesViewAllVerifiedWidget(),
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
            return '/landingPage';
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
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/Ebasura_icon.png',
                    fit: BoxFit.cover,
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
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
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
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
