import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/models/shop/shop.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/cart_details/cart_details.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/product_category/product_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).value!;
    final t = ref.watch(translationProvider).translations.home;

    return Scaffold(
      drawer: const SDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateShopDialogRoute().push(context),
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(t.createShopFABTitle),
          ],
        ),
      ).animate(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, isBoxScrolled) {
            return [
              SliverAppBar(
                title: Text(t.title),
                actions: const [
                  CartIconButton(),
                ],
                forceElevated: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      text: t.myShopsTabTitle,
                      icon: const Icon(Icons.person),
                    ),
                    Tab(
                      text: t.shopsTabTitle,
                      icon: const FaIcon(FontAwesomeIcons.globe),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ShopList(
                ownerId: authedUser.uid,
                isAuthedList: true,
              ),
              const ShopList(),
            ],
          ),
        ),
      ),
    );
  }
}

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
            CartRoute($extra: true).push(context);
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

class ShopList extends HookConsumerWidget {
  final String? ownerId;
  final bool isAuthedList;
  const ShopList({
    super.key,
    this.ownerId,
    this.isAuthedList = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authedUser = ref.watch(authStreamProvider).valueOrNull;
    return FirestoreListView<SShop>(
      pageSize: 20,
      itemBuilder: (context, snap) => SShopListWidget(
        snap.data(),
        isInAuthedList: isAuthedList,
      ),
      emptyBuilder: (context) {
        return Center(
          child: Lottie.asset('assets/lottiefiles/empty.json'),
        );
      },
      query: FirebaseFirestore.instance
          .collection(
            'shops',
          )
          .where(
            'ownerId',
            isEqualTo: ownerId,
          )
          .where(
            'ownerId',
            isNotEqualTo: isAuthedList ? null : authedUser?.uid,
          )
          .withConverter<SShop>(
            fromFirestore: (snapshot, _) => SShop.fromJson(snapshot.data()!),
            toFirestore: (product, _) => product.toJson(),
          ),
    );
  }
}

class SShopListWidget extends ConsumerWidget {
  final SShop shop;
  final bool isInAuthedList;
  const SShopListWidget(
    this.shop, {
    super.key,
    this.isInAuthedList = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(userStreamProvider(shop.ownerId));

    return owner.when(
      data: (owner) {
        return Consumer(
          builder: (context, ref, child) {
            final categoriesAsyncValue = ref.watch(
              productCategoryStreamProvider(shop.id),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: switch (!isInAuthedList) {
                    true => CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                          owner.profilePicture.link,
                        ),
                      ),
                    false => null,
                  },
                  title: Text(shop.name),
                  subtitle: switch (!isInAuthedList) {
                    true => Text(owner.name),
                    false => null,
                  },
                  onTap: () =>
                      ShopRoute(shop.id, $extra: isInAuthedList).push(context),
                ),
                categoriesAsyncValue.when(
                  data: (categories) {
                    if (categories.isEmpty) return const SizedBox();
                    final cats = categories.map((c) => c.category);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        cats.join(', '),
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    );
                  },
                  error: errorWidget,
                  loading: loadingWidget,
                ),
              ],
            );
          },
        );
      },
      error: errorWidget,
      loading: loadingWidget,
    );
  }
}

class ProductList extends ConsumerWidget {
  final String ownerId;
  final String shopId;
  const ProductList({
    super.key,
    required this.ownerId,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FirestoreListView<SProduct>(
      pageSize: 20,
      itemBuilder: (context, snap) => SProductListWidget(snap.data()),
      query: FirebaseFirestore.instance
          .collection(
            '/products',
          )
          .where(
            'shopId',
            isEqualTo: shopId,
          )
          .where(
            'ownerId',
            isEqualTo: ownerId,
          )
          .withConverter<SProduct>(
            fromFirestore: (snapshot, _) => SProduct.fromJson(snapshot.data()!),
            toFirestore: (product, _) => product.toJson(),
          ),
    );
  }
}

class SProductListWidget extends StatelessWidget {
  final SProduct product;
  const SProductListWidget(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Card(),
    );
  }
}
