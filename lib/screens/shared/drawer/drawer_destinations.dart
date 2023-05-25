import 'package:commercio/router/route_names.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drawer_destinations.g.dart';

class SDrawerDestionation extends NavigationDrawerDestination {
  final String routeName;

  const SDrawerDestionation({
    super.key,
    required this.routeName,
    required Widget icon,
    required Widget label,
  }) : super(icon: icon, label: label);
}

@Riverpod(keepAlive: true)
List<SDrawerDestionation> drawerDestinations(Ref ref) {
  final t = ref.watch(translationProvider).translations.drawer;

  return [
    SDrawerDestionation(
      icon: const Icon(Icons.home),
      label: Text(t.homeTileTitle),
      routeName: kHomeRouteName,
    ),
    SDrawerDestionation(
      icon: const FaIcon(FontAwesomeIcons.cartShopping),
      label: Text(t.cartTileTitle),
      routeName: kCartRouteName,
    ),
    SDrawerDestionation(
      icon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
      label: Text(t.pastPurchasesTileTitle),
      routeName: kPastPurchasesRouteName,
    ),
    SDrawerDestionation(
      icon: const FaIcon(FontAwesomeIcons.solidHeart),
      label: Text(t.likedProductTileTitle),
      routeName: kLikedProductsRouteName,
    ),
    SDrawerDestionation(
      icon: const FaIcon(FontAwesomeIcons.locationPin),
      label: Text(t.locationsTileTitle),
      routeName: kDeliveryLocationsRouteName,
    ),
    SDrawerDestionation(
      icon: const Icon(Icons.settings),
      label: Text(t.settingsTileTitle),
      routeName: kSettingsRouteName,
    ),
  ];
}
