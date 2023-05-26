import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/pick_delivery_location/widgets/pick_delivery_location_tile.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickDeliveryLocationScreen extends ConsumerWidget {
  const PickDeliveryLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStreamProvider).valueOrNull!;
    final t = ref.watch(translationProvider).translations.pickDeliveryLocation;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(t.title)),
          FirestoreSliverList<SLocation>(
            collectionPath: '/users/${user.uid}/deliveryLocations',
            fromJson: SLocation.fromJson,
            emptyBuilder: (context) {
              return ElevatedButton(
                onPressed: () {
                  DeliveryLocationsRoute($extra: false).push(context);
                },
                child: Text(t.emptyButtonTitle),
              );
            },
            builder: (_, index, entites) =>
                PickDeliveryLocationTile(location: entites[index]),
          )
        ],
      ),
    );
  }
}
