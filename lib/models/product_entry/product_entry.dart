import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/utils/utility_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entry.freezed.dart';
part 'product_entry.g.dart';

@freezed
class ProductEntry with _$ProductEntry implements BaseEntity {
  const factory ProductEntry({
    required String id,
    required String shopId,
    @TimestampConverter() DateTime? createdOn,
  }) = _ProductEntry;

  factory ProductEntry.fromJson(Map<String, dynamic> json) =>
      _$ProductEntryFromJson(json);
}
