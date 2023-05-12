import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_picture_model.freezed.dart';
part 'profile_picture_model.g.dart';

@freezed
class SProfilePicture with _$SProfilePicture {
  const factory SProfilePicture({
    int? width,
    int? height,
    required String link,
  }) = _SProfilePicture;
  factory SProfilePicture.fromJson(Map<String, dynamic> json) =>
      _$SProfilePictureFromJson(json);
}
