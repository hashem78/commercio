import 'package:commercio/models/location/location.dart';

import 'package:commercio/screens/delivery_locations/widgets/deliver_locations_screen_fab.dart';
import 'package:commercio/screens/delivery_locations/widgets/delivery_locations_screen_tile.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';

import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryLocationsScreen extends HookConsumerWidget {
  final bool showDrawer;
  const DeliveryLocationsScreen({
    super.key,
    required this.showDrawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStreamProvider).valueOrNull!;

    final t = ref.watch(translationProvider).translations.deliveryLocations;
    return Scaffold(
      drawer: showDrawer ? const SDrawer() : null,
      floatingActionButton: DeliveryLocationsScreenFAB(userId: user.uid),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(t.title)),
          FirestoreSliverList<SLocation>(
            collectionPath: '/users/${user.uid}/deliveryLocations',
            fromJson: SLocation.fromJson,
            builder: (_, index, entites) => DeliveryLocationsScreenTile(
              location: entites[index],
              userId: user.uid,
            ),
          )
        ],
      ),
    );
  }
}
