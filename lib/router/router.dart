import 'package:commercio/models/user/user_model.dart';
import 'package:commercio/screens/home/home_screen.dart';
import 'package:commercio/screens/login/login_screen.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/utils/go_router_refresh_stream.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<LoginRoute>(
  name: 'login',
  path: '/login',
)
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
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
