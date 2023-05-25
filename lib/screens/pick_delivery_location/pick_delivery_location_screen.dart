import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PickDeliveryLocationScreen extends ConsumerWidget {
  const PickDeliveryLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStreamProvider).valueOrNull!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Pick Delivery Location'),
          ),
          FirestoreSliverList<SLocation>(
            collectionPath: '/users/${user.uid}/deliveryLocations',
            fromJson: SLocation.fromJson,
            emptyBuilder: (context) {
              return ElevatedButton(
                onPressed: () {
                  DeliveryLocationsRoute($extra: false).push(context);
                },
                child: const Text('Add a Location'),
              );
            },
            builder: (context, index, entites) {
              final location = entites[index];
              return ListTile(
                title: Text(location.address),
                subtitle: Text('${location.lat}, ${location.lng}'),
                onTap: () {
                  context.pop<SLocation?>(location);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
