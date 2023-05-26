import 'package:commercio/screens/cart/widgets/continue_purchase_button.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/cart_details/cart_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContinuePurchaseCard extends ConsumerWidget {
  final String uid;
  const ContinuePurchaseCard({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartDetailsAsyncValue = ref.watch(cartDetailsStreamProvider);

    return cartDetailsAsyncValue.when(
      data: (details) {
        if (details.itemCount == 0) return const SizedBox();
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.bagShopping),
                title: Text('${details.itemCount} items'),
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: Text('JOD ${details.totalPrice.toStringAsFixed(2)}'),
              ),
              const Divider(),
              ContinuePurchaseButton(uid: uid),
            ],
          ),
        );
      },
      error: errorWidget,
      loading: () => loadingWidget(const Size(double.infinity, 75)),
    );
  }
}
