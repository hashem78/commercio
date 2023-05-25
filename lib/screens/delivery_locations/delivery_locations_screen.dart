import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/current_location/current_location.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final isMounted = useIsMounted();
    final t = ref.watch(translationProvider).translations.deliveryLocations;
    return Scaffold(
      drawer: showDrawer ? const SDrawer() : null,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(t.addLocationFABTitle),
        onPressed: () async {
          try {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(content: Text(t.gettingYourLocation)),
            );
            final location = await ref.read(
              currentLocationFutureProvider.future,
            );

            final db = FirebaseFirestore.instance;

            if (isMounted()) {
              SLocation? actualLocation =
                  // ignore: use_build_context_synchronously
                  await PickLocationRoute($extra: location)
                      .push<SLocation?>(context);

              actualLocation ??= location;

              await db
                  .doc(
                    '/users/${user.uid}/deliveryLocations/${actualLocation.id}',
                  )
                  .set(actualLocation.toJson());
            }
          } catch (e) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(t.title),
          ),
          FirestoreSliverList<SLocation>(
            collectionPath: '/users/${user.uid}/deliveryLocations',
            fromJson: SLocation.fromJson,
            builder: (context, index, entites) {
              final location = entites[index];
              return ListTile(
                title: Text(location.address),
                subtitle: Text('${location.lat}, ${location.lng}'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    final db = FirebaseFirestore.instance;
                    await db
                        .doc(
                          '/users/${user.uid}/deliveryLocations/${location.id}',
                        )
                        .delete();
                  },
                ),
                onTap: () {
                  LocationRoute($extra: location).push(context);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
