import 'package:commercio/models/location/location.dart';
import 'package:commercio/models/product/product.dart';
import 'package:commercio/repositories/generic_repository.dart';

import 'package:commercio/utils/utility_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

part 'past_purchase.freezed.dart';
part 'past_purchase.g.dart';

@freezed
class PastPurchase with _$PastPurchase implements BaseEntity {
  @Implements<BaseEntity>()
  const factory PastPurchase({
    required String id,
    required SLocation location,
    @Default([]) List<SProduct> products,
    @Default(0) double totalPrice,
    @TimestampConverter() DateTime? createdOn,
  }) = _PastPurchase;
  factory PastPurchase.fromJson(Map<String, dynamic> json) =>
      _$PastPurchaseFromJson(json);
}
