import 'package:commercio/models/profile_picture/profile_picture_model.dart';
import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class SUser with _$SUser implements BaseEntity {
  const SUser._();

  @Implements<BaseEntity>()
  const factory SUser({
    @Default("")
        String id,
    @Default("")
        String name,
    @Default("")
        String email,
    @Default("")
        String phoneNumber,
    @Default(
      SProfilePicture(
        link: 'https://i.imgur.com/kEqAm6K.png',
        width: 120,
        height: 120,
      ),
    )
        SProfilePicture profilePicture,
    @Default({})
        Map<SocialEntryType, SocialEntry> socialEntriesMap,
  }) = _SUser;

  factory SUser.fromJson(Map<String, dynamic> json) => _$SUserFromJson(json);
}
