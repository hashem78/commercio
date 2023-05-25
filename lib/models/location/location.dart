import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class SLocation with _$SLocation{
  const factory SLocation({
    required double lat,
    required double lng,
    required String address,
  }) = _SLocation;
  factory SLocation.fromJson(Map<String, dynamic> json) => _$SLocationFromJson(json);
}