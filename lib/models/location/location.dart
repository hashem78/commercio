import 'package:commercio/models/base_entity.dart';
import 'package:commercio/utils/utility_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class SLocation with _$SLocation implements BaseEntity {
  const factory SLocation({
    required String id,
    required double lat,
    required double lng,
    required String address,
    @TimestampConverter() DateTime? createdOn,
  }) = _SLocation;
  factory SLocation.fromJson(Map<String, dynamic> json) =>
      _$SLocationFromJson(json);
}
