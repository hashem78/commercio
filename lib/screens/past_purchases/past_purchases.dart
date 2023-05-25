import 'package:commercio/models/past_purchase/past_purchase.dart';
import 'package:commercio/screens/past_purchases/widgets/past_purchase_tile.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PastPurchasesScreen extends ConsumerWidget {
  const PastPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull!;
    final t = ref.watch(translationProvider).translations.pastPurchases;

    return Scaffold(
      drawer: const SDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(t.title)),
          FirestoreSliverList<PastPurchase>(
            collectionPath: '/users/${authedUser.uid}/purchases',
            fromJson: PastPurchase.fromJson,
            builder: (_, index, entities) =>
                PastPurchaseTile(pastPurchase: entities[index]),
          )
        ],
      ),
    );
  }
}
