import 'package:commercio/models/product/product.dart';
import 'package:commercio/screens/past_purchase_details/widgets/past_purchase_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PastPurchaseDetailsScreen extends ConsumerWidget {
  final List<SProduct> products;
  const PastPurchaseDetailsScreen({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Past Purchases'),
          ),
          SliverList.builder(
            itemBuilder: (context, index) => PastPurchaseProductCard(
              product: products[index],
            ),
            itemCount: products.length,
          )
        ],
      ),
    );
  }
}
