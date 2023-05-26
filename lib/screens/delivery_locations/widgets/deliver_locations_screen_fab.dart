import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/state/current_location/current_location.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryLocationsScreenFAB extends HookConsumerWidget {
  final String userId;
  const DeliveryLocationsScreenFAB({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    final t = ref.watch(translationProvider).translations.deliveryLocations;
    return FloatingActionButton.extended(
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
                  '/users/$userId/deliveryLocations/${actualLocation.id}',
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
    );
  }
}
