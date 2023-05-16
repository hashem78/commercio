import 'package:commercio/models/profile_picture/picture.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class SProduct with _$SProduct implements BaseEntity {
  @Implements<BaseEntity>()
  const factory SProduct(
      {required String id,
      required String shopId,
      required String creatorId,
      required String name,
      required String description,
      required double price,
      required bool inStock,
      required SPicture picture,
      DateTime? createdOn}) = _SProduct;
  factory SProduct.fromJson(Map<String, dynamic> json) =>
      _$SProductFromJson(json);
}