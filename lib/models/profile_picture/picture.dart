import 'package:freezed_annotation/freezed_annotation.dart';
part 'picture.freezed.dart';
part 'picture.g.dart';

@freezed
class SPicture with _$SPicture {
  const factory SPicture({
    int? width,
    int? height,
    required String link,
  }) = _SProfilePicture;
  factory SPicture.fromJson(Map<String, dynamic> json) =>
      _$SPictureFromJson(json);
}
