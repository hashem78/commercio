import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercio/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PastPurchaseProductCard extends ConsumerWidget {
  final SProduct product;

  const PastPurchaseProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    product.pictures.first.link,
                  ),
                ),
              ),
            ),
            70.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 70.sp,
                    ),
                  ),
                  Text(
                    product.description,
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 50.sp,
                    ),
                  ),
                  Text(
                    product.price.toString(),
                    style: TextStyle(
                      fontSize: 35.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
