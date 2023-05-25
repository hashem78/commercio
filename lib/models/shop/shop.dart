import 'package:commercio/models/location/location.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/utils/utility_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

part 'shop.freezed.dart';
part 'shop.g.dart';

@freezed
class SShop with _$SShop implements BaseEntity {
  @Implements<BaseEntity>()
  const factory SShop(
    String id,
    String ownerId,
    String name, {
    SLocation? location,
    @TimestampConverter() DateTime? createdOn,
  }) = _SShop;
  factory SShop.fromJson(Map<String, dynamic> json) => _$SShopFromJson(json);
}
