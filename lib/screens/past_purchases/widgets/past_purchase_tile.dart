import 'package:commercio/models/past_purchase/past_purchase.dart';
import 'package:commercio/router/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastPurchaseTile extends StatelessWidget {
  const PastPurchaseTile({
    super.key,
    required this.pastPurchase,
  });

  final PastPurchase pastPurchase;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(pastPurchase.totalPrice.toStringAsFixed(2)),
      subtitle: Text(DateFormat.yMMMEd().format(pastPurchase.createdOn!)),
      onTap: () {
        PastPurchaseProductDetailsRoute(pastPurchase.products).push(context);
      },
    );
  }
}
