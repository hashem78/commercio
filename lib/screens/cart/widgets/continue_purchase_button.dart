import 'package:commercio/models/location/location.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContinuePurchaseButton extends HookConsumerWidget {
  const ContinuePurchaseButton({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.cart;
    final isMounted = useIsMounted();
    return TextButton(
      onPressed: () async {
        final location = await PickDeliveryLocationRoute().push<SLocation?>(
          context,
        );
        if (location == null) {
          if (!isMounted()) return;

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(
              content: Text(
                'You need to pick a location!',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
          return;
        }

        if (!isMounted()) return;

        // ignore: use_build_context_synchronously
        await LoadingRoute(
          $extra: const Duration(seconds: 1),
        ).push(context);

        if (!isMounted()) return;

        // ignore: use_build_context_synchronously
        await PurchaseCompleteRoute((
          uid: uid,
          location: location,
        )).push(context);
      },
      child: Text(t.continueButtonText),
    );
  }
}
