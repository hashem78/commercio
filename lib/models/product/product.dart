import 'package:commercio/models/product_category/product_category.dart';
import 'package:commercio/models/profile_picture/picture.dart';
import 'package:commercio/models/base_entity.dart';
import 'package:commercio/utils/utility_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
part 'product.freezed.dart';
part 'product.g.dart';

enum ProductAvailability {
  inStock,
  outOfStock,
}

@freezed
class SProduct with _$SProduct implements BaseEntity {
  @Implements<BaseEntity>()
  const factory SProduct({
    required String id,
    required String shopId,
    required String name,
    required String description,
    required double price,
    required ProductAvailability availability,
    required List<SPicture> pictures,
    required List<ProductCategory> categories,
    required int likeCount,
    @TimestampConverter() DateTime? createdOn,
  }) = _SProduct;
  factory SProduct.fromJson(Map<String, dynamic> json) =>
      _$SProductFromJson(json);
}
