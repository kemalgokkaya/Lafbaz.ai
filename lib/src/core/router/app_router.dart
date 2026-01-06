import 'package:auto_route/auto_route.dart';
import 'package:lafbaz_ai/src/core/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ResultRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: HistoryRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: SplashRoute.page, initial: true),
  ];
}
