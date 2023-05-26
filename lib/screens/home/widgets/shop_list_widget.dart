import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercio/models/shop/shop.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/product_category/product_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
