import 'package:cloud_functions/cloud_functions.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteShopTextButton extends HookConsumerWidget {
  const DeleteShopTextButton({
    super.key,
    required this.shopId,
  });

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    final t = ref.watch(translationProvider).translations;

    return TextButton(
      onPressed: () async {
        final func = FirebaseFunctions.instance;
        await func.httpsCallable('deleteShop').call({
          'shopId': shopId,
        });
        // ignore: use_build_context_synchronously
        if (isMounted()) context.pop();
      },
      child: Text(
        t.shop.deleteIconButtonText,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
