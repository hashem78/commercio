import 'dart:async';

import 'package:commercio/models/location/location.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/router/route_names.dart';
import 'package:commercio/screens/cart/cart_screen.dart';
import 'package:commercio/screens/delivery_locations/delivery_locations_screen.dart';
import 'package:commercio/screens/edit_categories/edit_categories_screen.dart';
import 'package:commercio/screens/location/location_screen.dart';
import 'package:commercio/screens/pick_delivery_location/pick_delivery_location_screen.dart';
import 'package:commercio/screens/pick_location/pick_location_screen.dart';
import 'package:commercio/screens/product/add_product_screen.dart';
import 'package:commercio/screens/product/edit_product_screen.dart';
import 'package:commercio/screens/edit_socials_screen/edit_social_modal_dialog.dart';
import 'package:commercio/screens/edit_socials_screen/edit_socials_screen.dart';
import 'package:commercio/screens/home/create_shop_modal_dialog.dart';
import 'package:commercio/screens/home/home_screen.dart';
import 'package:commercio/screens/liked_products/liked_products_screen.dart';
import 'package:commercio/screens/loading/loading_screen.dart';
import 'package:commercio/screens/login/login_screen.dart';
import 'package:commercio/screens/past_purchase_details/past_purchase_details_screen.dart';
import 'package:commercio/screens/past_purchases/past_purchases.dart';
import 'package:commercio/screens/profile/profile_screen.dart';
import 'package:commercio/screens/purchase_complete/purchase_complete_screen.dart';
import 'package:commercio/screens/settings/settings_screen.dart';
import 'package:commercio/screens/shop/create_category_dialog.dart';
import 'package:commercio/screens/shop/shop_screen.dart';
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

@TypedGoRoute<CreateShopDialogRoute>(
  name: kCreateShopDialogRouteName,
  path: '/createShopDialog',
)
class CreateShopDialogRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: CreateShopModalDialog(),
      fullscreenDialog: true,
    );
  }
}

@TypedGoRoute<LoadingRoute>(
  name: kLoadingRouteName,
  path: '/loading',
)
class LoadingRoute extends GoRouteData {
  final Duration? $extra;

  LoadingRoute({this.$extra});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoadingScreen(duration: $extra);
  }
}

@TypedGoRoute<ShopRoute>(
  name: kShopRouteName,
  path: '/shop/:shopId',
)
class ShopRoute extends GoRouteData {
  final String shopId;
  final bool $extra;

  ShopRoute(this.shopId, {this.$extra = false});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ShopScreen(shopId: shopId, allowEditing: $extra);
  }
}

@TypedGoRoute<AddProductRoute>(
  name: kAddProductDialogRouteName,
  path: '/shop/:shopId/addProduct',
)
class AddProductRoute extends GoRouteData {
  final String shopId;

  AddProductRoute(this.shopId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddProductScreen(shopId: shopId);
  }
}

@TypedGoRoute<EditCategoriesRoute>(
  name: kEditCategoriesRouteName,
  path: '/shop/:shopId/editCategories',
)
class EditCategoriesRoute extends GoRouteData {
  final String shopId;

  EditCategoriesRoute(this.shopId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditCategoriesScreen(shopId: shopId);
  }
}

@TypedGoRoute<CreateCategoryRoute>(
  name: kCreateCategoryRouteName,
  path: '/shop/:shopId/editCategories/createCategory',
)
class CreateCategoryRoute extends GoRouteData {
  final String shopId;

  CreateCategoryRoute({required this.shopId});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      child: CreateCategoryDialog(shopId: shopId),
      fullscreenDialog: true,
    );
  }
}

@TypedGoRoute<CartRoute>(
  name: kCartRouteName,
  path: '/cart',
)
class CartRoute extends GoRouteData {
  final bool $extra;

  CartRoute({this.$extra = true});

  @override
  Widget build(BuildContext context, GoRouterState state) => CartScreen(
        showDrawer: $extra,
      );
}

@TypedGoRoute<LikedProductsRoute>(
  name: kLikedProductsRouteName,
  path: '/likedProducts',
)
class LikedProductsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LikedProductsScreen();
}

@TypedGoRoute<PurchaseCompleteRoute>(
  name: kPurchaseCompleteRouteName,
  path: '/purchaseCompelete',
)
class PurchaseCompleteRoute extends GoRouteData {
  final ({String uid, SLocation location}) $extra;

  PurchaseCompleteRoute(this.$extra);
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PurchaseCompleteScreen(data: $extra);
}

@TypedGoRoute<PastPurchasesRoute>(
  name: kPastPurchasesRouteName,
  path: '/pastPurchases',
)
class PastPurchasesRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PastPurchasesScreen();
}

@TypedGoRoute<PastPurchaseProductDetailsRoute>(
  name: kPastPurchaseProductDetailsRouteName,
  path: '/pastPurchaseDetails',
)
class PastPurchaseProductDetailsRoute extends GoRouteData {
  final List<SProduct> $extra;

  PastPurchaseProductDetailsRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PastPurchaseDetailsScreen(products: $extra);
}

@TypedGoRoute<EditProductRoute>(
  name: kEditProductRouteName,
  path: '/editProduct',
)
class EditProductRoute extends GoRouteData {
  final SProduct $extra;

  EditProductRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditProductScreen(product: $extra);
}

@TypedGoRoute<PickLocationRoute>(
  name: kPickLocationRouteName,
  path: '/pickLocation',
)
class PickLocationRoute extends GoRouteData {
  final SLocation? $extra;

  PickLocationRoute({this.$extra});
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PickLocationScreen(initialLocation: $extra);
}

@TypedGoRoute<LocationRoute>(
  name: kLocationRouteName,
  path: '/location',
)
class LocationRoute extends GoRouteData {
  final SLocation $extra;

  LocationRoute({required this.$extra});
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LocationScreen(location: $extra);
}

@TypedGoRoute<DeliveryLocationsRoute>(
  name: kDeliveryLocationsRouteName,
  path: '/deliveryLocations',
)
class DeliveryLocationsRoute extends GoRouteData {
  final bool $extra;

  DeliveryLocationsRoute({this.$extra = true});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DeliveryLocationsScreen(showDrawer: $extra);
}

@TypedGoRoute<PickDeliveryLocationRoute>(
  name: kPickDeliveryLocationRouteName,
  path: '/pickDeliveryLocation',
)
class PickDeliveryLocationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PickDeliveryLocationScreen();
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
