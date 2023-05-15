import 'dart:async';

import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/router/route_names.dart';
import 'package:commercio/screens/edit_socials_screen/edit_social_modal_dialog.dart';
import 'package:commercio/screens/edit_socials_screen/edit_socials_screen.dart';
import 'package:commercio/screens/home/home_screen.dart';
import 'package:commercio/screens/login/login_screen.dart';
import 'package:commercio/screens/profile/profile_screen.dart';
import 'package:commercio/screens/settings/settings_screen.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(
  name: kHomeRouteName,
  path: '/',
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<LoginRoute>(
  name: kLoginRouteName,
  path: '/login',
)
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<SettingsRoute>(
  name: kSettingsRouteName,
  path: '/settings',
)
class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@TypedGoRoute<ProfileRoute>(
  name: kProfileRouteName,
  path: '/profile/:userId',
)
class ProfileRoute extends GoRouteData {
  final String userId;

  ProfileRoute({required this.userId});
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProfileScreen(userId: userId);
}

@TypedGoRoute<EditSocialsRoute>(
  name: kEditSocialsRouteName,
  path: '/profile/:userId/editSocials',
)
class EditSocialsRoute extends GoRouteData {
  final String userId;

  EditSocialsRoute({required this.userId});
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditSocialsScreen(userId: userId);

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) =>
      unauthorizedRedirect(context, userId);
}

@TypedGoRoute<EditSocialsDialogRoute>(
  name: kEditSocialDialogRouteName,
  path: '/profile/:userId/editSocials/dialog',
)
class EditSocialsDialogRoute extends GoRouteData {
  final String userId;
  final (SocialEntryType entryType, String link) $extra;

  EditSocialsDialogRoute({
    required this.userId,
    required this.$extra,
  });

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      child: EditSocialModalDialog(
        userId: userId,
        entryType: $extra.$1,
        link: $extra.$2,
      ),
      fullscreenDialog: true,
    );
  }

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) =>
      unauthorizedRedirect(context, userId);
}

@TypedGoRoute<LoadingRoute>(
  name: kLoadingRouteName,
  path: '/loading',
)
class LoadingRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (context, state) {
      // if the user is not logged in, they need to login
      final isLoggingIn = state.matchedLocation == '/login';
      final authState = ref.watch(authStreamProvider);

      return authState.whenOrNull(
        data: (user) {
          //
          final isNotLoggedIn = user == null;
          if (isNotLoggedIn) return isLoggingIn ? null : '/login';

          // if the user is logged in but still on the login page, send them to
          // the home page
          if (isLoggingIn) return '/';

          // no need to redirect at all
          return null;
        },
        loading: () {
          return '/loading';
        },
      );
    },
  );
}
