import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/cart_details/cart_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartIconButton extends ConsumerWidget {
  const CartIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartDetailsAsyncValue = ref.watch(cartDetailsStreamProvider);
    return cartDetailsAsyncValue.when(
      data: (details) {
        return IconButton(
          onPressed: () {
            CartRoute($extra: false).push(context);
          },
          icon: Badge.count(
            count: details.itemCount,
            child: const FaIcon(FontAwesomeIcons.cartShopping),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: FaIcon(FontAwesomeIcons.cartShopping),
      ),
      error: errorWidget,
    );
  }
}
