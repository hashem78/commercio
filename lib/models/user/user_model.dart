import 'package:commercio/models/cart_details/cart_details.dart';
import 'package:commercio/models/profile_picture/picture.dart';
import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/utils/utility_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class SUser with _$SUser implements BaseEntity {
  const SUser._();

  @Implements<BaseEntity>()
  const factory SUser({
    @Default("") String id,
    @Default("") String name,
    @Default("") String email,
    @Default("") String phoneNumber,
    @Default(
      SPicture(
        link: 'https://i.imgur.com/kEqAm6K.png',
        width: 120,
        height: 120,
      ),
    )
    SPicture profilePicture,
    @TimestampConverter() DateTime? createdOn,
    @Default({}) Map<SocialEntryType, SocialEntry> socialEntriesMap,
    @Default(CartDetails()) CartDetails cartDetails,
  }) = _SUser;

  factory SUser.fromJson(Map<String, dynamic> json) => _$SUserFromJson(json);
}
