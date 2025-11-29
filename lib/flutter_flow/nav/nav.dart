import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';
import '/pages/harvest_scorecard/harvest_scorecard_widget.dart';
import '/pages/subscription_page/subscription_page_widget.dart';

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
          appStateNotifier.loggedIn ? NavBarPage() : LoginPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? NavBarPage() : LoginPageWidget(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HomePage')
              : HomePageWidget(
                  cat02: params.getParam(
                    'cat02',
                    ParamType.String,
                  ),
                ),
        ),
        FFRoute(
          name: LoginPageWidget.routeName,
          path: LoginPageWidget.routePath,
          builder: (context, params) => LoginPageWidget(),
        ),
        FFRoute(
          name: TowerCatalogWidget.routeName,
          path: TowerCatalogWidget.routePath,
          builder: (context, params) => TowerCatalogWidget(),
        ),
        FFRoute(
          name: PortCountInputWidget.routeName,
          path: PortCountInputWidget.routePath,
          builder: (context, params) => PortCountInputWidget(
            towerBrandID: params.getParam(
              'towerBrandID',
              ParamType.int,
            ),
            brandName: params.getParam(
              'brandName',
              ParamType.String,
            ),
            allowCustomName: params.getParam(
              'allowCustomName',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: NameTowerNewWidget.routeName,
          path: NameTowerNewWidget.routePath,
          builder: (context, params) => NameTowerNewWidget(
            towerID: params.getParam(
              'towerID',
              ParamType.int,
            ),
            portCount: params.getParam(
              'portCount',
              ParamType.int,
            ),
            customBrandName: params.getParam(
              'customBrandName',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: IndoorOutdoorNewWidget.routeName,
          path: IndoorOutdoorNewWidget.routePath,
          builder: (context, params) => IndoorOutdoorNewWidget(
            towerName: params.getParam(
              'towerName',
              ParamType.String,
            ),
            towerID: params.getParam(
              'towerID',
              ParamType.int,
            ),
            portCount: params.getParam(
              'portCount',
              ParamType.int,
            ),
            customBrandName: params.getParam(
              'customBrandName',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PlantCatagoriesWidget.routeName,
          path: PlantCatagoriesWidget.routePath,
          builder: (context, params) => PlantCatagoriesWidget(
            categoryID: params.getParam(
              'categoryID',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: PlantFavoritesWidget.routeName,
          path: PlantFavoritesWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'plantFavorites')
              : PlantFavoritesWidget(
                  myPlantID: params.getParam(
                    'myPlantID',
                    ParamType.int,
                  ),
                ),
        ),
        FFRoute(
          name: OnboardingFlowWidget.routeName,
          path: OnboardingFlowWidget.routePath,
          builder: (context, params) => OnboardingFlowWidget(),
        ),
        FFRoute(
          name: UserProfileWidget.routeName,
          path: UserProfileWidget.routePath,
          builder: (context, params) => UserProfileWidget(
            userID: params.getParam(
              'userID',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: SubmitForPestsWidget.routeName,
          path: SubmitForPestsWidget.routePath,
          builder: (context, params) => SubmitForPestsWidget(),
        ),
        FFRoute(
          name: SupportGrowBetterWidget.routeName,
          path: SupportGrowBetterWidget.routePath,
          builder: (context, params) => SupportGrowBetterWidget(),
        ),
        FFRoute(
          name: PestSupport2Widget.routeName,
          path: PestSupport2Widget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'pestSupport2')
              : PestSupport2Widget(),
        ),
        FFRoute(
          name: AphidsDetailWidget.routeName,
          path: AphidsDetailWidget.routePath,
          builder: (context, params) => AphidsDetailWidget(),
        ),
        FFRoute(
          name: CustomerSupportWidget.routeName,
          path: CustomerSupportWidget.routePath,
          builder: (context, params) => CustomerSupportWidget(),
        ),
        FFRoute(
          name: OnboardingQuestionsWidget.routeName,
          path: OnboardingQuestionsWidget.routePath,
          builder: (context, params) => OnboardingQuestionsWidget(),
        ),
        FFRoute(
          name: MainFAQWidget.routeName,
          path: MainFAQWidget.routePath,
          builder: (context, params) => MainFAQWidget(),
        ),
        FFRoute(
          name: MyTowersExpandableWidget.routeName,
          path: MyTowersExpandableWidget.routePath,
          builder: (context, params) => MyTowersExpandableWidget(
            userID: params.getParam(
              'userID',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: EditTowerWidget.routeName,
          path: EditTowerWidget.routePath,
          builder: (context, params) => EditTowerWidget(
            towerID: params.getParam(
              'towerID',
              ParamType.int,
            ),
            towerName: params.getParam(
              'towerName',
              ParamType.String,
            ),
            portCount: params.getParam(
              'portCount',
              ParamType.int,
            ),
            indoorOutdoor: params.getParam(
              'indoorOutdoor',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CreateAnAccountWidget.routeName,
          path: CreateAnAccountWidget.routePath,
          builder: (context, params) => CreateAnAccountWidget(),
        ),
        FFRoute(
          name: MyPlantExpandableCopyWidget.routeName,
          path: MyPlantExpandableCopyWidget.routePath,
          builder: (context, params) => MyPlantExpandableCopyWidget(),
        ),
        FFRoute(
          name: ResetPasswordWidget.routeName,
          path: ResetPasswordWidget.routePath,
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: WhitefliesDetailWidget.routeName,
          path: WhitefliesDetailWidget.routePath,
          builder: (context, params) => WhitefliesDetailWidget(),
        ),
        FFRoute(
          name: GnatsDetailWidget.routeName,
          path: GnatsDetailWidget.routePath,
          builder: (context, params) => GnatsDetailWidget(),
        ),
        FFRoute(
          name: PesticideDetailWidget.routeName,
          path: PesticideDetailWidget.routePath,
          builder: (context, params) => PesticideDetailWidget(),
        ),
        FFRoute(
          name: BeneficialsDetailWidget.routeName,
          path: BeneficialsDetailWidget.routePath,
          builder: (context, params) => BeneficialsDetailWidget(),
        ),
        FFRoute(
          name: PlantDetail3Widget.routeName,
          path: PlantDetail3Widget.routePath,
          builder: (context, params) => PlantDetail3Widget(
            plantName: params.getParam(
              'plantName',
              ParamType.String,
            ),
            plantID: params.getParam(
              'plantID',
              ParamType.int,
            ),
            isFavorite: params.getParam(
              'isFavorite',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: UpdateProfileWidget.routeName,
          path: UpdateProfileWidget.routePath,
          builder: (context, params) => UpdateProfileWidget(
            userID: params.getParam(
              'userID',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: DecideOnTowerWidget.routeName,
          path: DecideOnTowerWidget.routePath,
          builder: (context, params) => DecideOnTowerWidget(
            userID: params.getParam(
              'userID',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: LoginPageRedirectWidget.routeName,
          path: LoginPageRedirectWidget.routePath,
          builder: (context, params) => LoginPageRedirectWidget(),
        ),
        FFRoute(
          name: MyCostsWidget.routeName,
          path: MyCostsWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'myCosts')
              : MyCostsWidget(),
        ),
        FFRoute(
          name: HarvestScorecardWidget.routeName,
          path: HarvestScorecardWidget.routePath,
          builder: (context, params) => HarvestScorecardWidget(),
        ),
        FFRoute(
          name: SubscriptionPageWidget.routeName,
          path: SubscriptionPageWidget.routePath,
          builder: (context, params) => SubscriptionPageWidget(),
        ),
        FFRoute(
          name: ProductViewWidget.routeName,
          path: ProductViewWidget.routePath,
          builder: (context, params) => ProductViewWidget(
            catagoryID: params.getParam(
              'catagoryID',
              ParamType.int,
            ),
            productID: params.getParam(
              'productID',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: SuppliesDetailWidget.routeName,
          path: SuppliesDetailWidget.routePath,
          builder: (context, params) => SuppliesDetailWidget(
            productID: params.getParam(
              'productID',
              ParamType.int,
            ),
            productName: params.getParam(
              'productName',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ProductCategoriesWidget.routeName,
          path: ProductCategoriesWidget.routePath,
          builder: (context, params) => ProductCategoriesWidget(),
        ),
        FFRoute(
          name: MySuppliesWidget.routeName,
          path: MySuppliesWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'mySupplies')
              : MySuppliesWidget(
                  userID: params.getParam(
                    'userID',
                    ParamType.String,
                  ),
                ),
        ),
        FFRoute(
          name: CommunityFeedWidget.routeName,
          path: CommunityFeedWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'community')
              : CommunityFeedWidget(),
        ),
        FFRoute(
          name: BadgesPage.routeName,
          path: BadgesPage.routePath,
          builder: (context, params) => BadgesPage(
            userId: params.getParam(
              'userId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: Settings1AddProfileWidget.routeName,
          path: Settings1AddProfileWidget.routePath,
          builder: (context, params) => Settings1AddProfileWidget(
            userID: params.getParam(
              'userID',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PlantCatalogWidget.routeName,
          path: PlantCatalogWidget.routePath,
          builder: (context, params) => PlantCatalogWidget(),
        ),
        FFRoute(
          name: FaqSearchResultsWidget.routeName,
          path: FaqSearchResultsWidget.routePath,
          builder: (context, params) => FaqSearchResultsWidget(
            searchTerm: params.getParam(
              'searchTerm',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CoralChatWidget.routeName,
          path: CoralChatWidget.routePath,
          builder: (context, params) => CoralChatWidget(),
        ),
        FFRoute(
          name: WormsDetail2Widget.routeName,
          path: WormsDetail2Widget.routePath,
          builder: (context, params) => WormsDetail2Widget(),
        ),
        FFRoute(
          name: OnboardingQuestionsCopyWidget.routeName,
          path: OnboardingQuestionsCopyWidget.routePath,
          builder: (context, params) => OnboardingQuestionsCopyWidget(
            userID: params.getParam(
              'userID',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PlantSelectorWidget.routeName,
          path: PlantSelectorWidget.routePath,
          builder: (context, params) => PlantSelectorWidget(),
        ),
        FFRoute(
          name: OutdoorPlantsWidget.routeName,
          path: OutdoorPlantsWidget.routePath,
          requireAuth: true,
          builder: (context, params) => OutdoorPlantsWidget(),
        ),
        FFRoute(
          name: IndoorPlantsWidget.routeName,
          path: IndoorPlantsWidget.routePath,
          requireAuth: true,
          builder: (context, params) => IndoorPlantsWidget(),
        ),
        FFRoute(
          name: TowerCatalogNewWidget.routeName,
          path: TowerCatalogNewWidget.routePath,
          builder: (context, params) => TowerCatalogNewWidget(),
        ),
        FFRoute(
          name: CreateNewPasswordWidget.routeName,
          path: CreateNewPasswordWidget.routePath,
          builder: (context, params) => CreateNewPasswordWidget(
            code: params.getParam(
              'code',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CreateNewPasswordInternalWidget.routeName,
          path: CreateNewPasswordInternalWidget.routePath,
          builder: (context, params) => CreateNewPasswordInternalWidget(),
        ),
        FFRoute(
          name: ChatAiScreenWidget.routeName,
          path: ChatAiScreenWidget.routePath,
          builder: (context, params) => ChatAiScreenWidget(),
        ),
        FFRoute(
          name: NotificationsMainWidget.routeName,
          path: NotificationsMainWidget.routePath,
          builder: (context, params) => NotificationsMainWidget(),
        ),
        FFRoute(
          name: NameTowerWidget.routeName,
          path: NameTowerWidget.routePath,
          builder: (context, params) => NameTowerWidget(
            towerID: params.getParam(
              'towerID',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: IndoorOutdoorTowerWidget.routeName,
          path: IndoorOutdoorTowerWidget.routePath,
          builder: (context, params) => IndoorOutdoorTowerWidget(
            towerName: params.getParam(
              'towerName',
              ParamType.String,
            ),
            towerID: params.getParam(
              'towerID',
              ParamType.int,
            ),
            portCount: params.getParam(
              'portCount',
              ParamType.int,
            ),
            customBrandName: params.getParam(
              'customBrandName',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: OnboardingQuestionsCopy2Widget.routeName,
          path: OnboardingQuestionsCopy2Widget.routePath,
          builder: (context, params) => OnboardingQuestionsCopy2Widget(),
        ),
        FFRoute(
          name: PlantCatalogCopyWidget.routeName,
          path: PlantCatalogCopyWidget.routePath,
          builder: (context, params) => PlantCatalogCopyWidget(),
        ),
        FFRoute(
          name: SproutifyPurchasePageWidget.routeName,
          path: SproutifyPurchasePageWidget.routePath,
          builder: (context, params) => SproutifyPurchasePageWidget(),
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
            return '/loginPage';
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
              ? isWeb
                  ? Container()
                  : Container(
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/splash_page.png',
                        fit: BoxFit.contain,
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
