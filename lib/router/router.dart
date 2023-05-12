import 'package:commercio/models/user/user_model.dart';
import 'package:commercio/router/route_names.dart';
import 'package:commercio/screens/home/home_screen.dart';
import 'package:commercio/screens/login/login_screen.dart';
import 'package:commercio/screens/settings/settings_screen.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/utils/go_router_refresh_stream.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

sealed class SRoute extends GoRouteData {
  String get routeName;
}

@TypedGoRoute<HomeRoute>(
  name: kHomeRouteName,
  path: '/',
)
class HomeRoute extends SRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();

  @override
  String get routeName => kSettingsRouteName;
}

@TypedGoRoute<LoginRoute>(
  name: kLoginRouteName,
  path: '/login',
)
class LoginRoute extends SRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();

  @override
  String get routeName => kLoginRouteName;
}

@TypedGoRoute<SettingsRoute>(
  name: kSettingsRouteName,
  path: '/settings',
)
class SettingsRoute extends SRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();

  @override
  String get routeName => kSettingsRouteName;
}

final routerProvider = Provider<GoRouter>(
  (ref) {
    final auth = ref.watch(authProvider.notifier);
    return GoRouter(
      refreshListenable: GoRouterRefreshStream(auth.stream),
      debugLogDiagnostics: true,
      routes: $appRoutes,
      redirect: (context, state) {
        // if the user is not logged in, they need to login
        final isLoggingIn = state.matchedLocation == '/login';
        final authState = ref.read(authProvider);
        final isNotLoggedIn = authState == const SUser();
        if (isNotLoggedIn) {
          return isLoggingIn ? null : '/login';
        }

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (isLoggingIn) {
          return '/';
        }

        // no need to redirect at all
        return null;
      },
    );
  },
);
