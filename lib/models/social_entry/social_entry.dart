import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_entry.freezed.dart';
part 'social_entry.g.dart';

enum SocialEntryType {
  facebook,
  twitter,
  instagram,
  whatsapp,
}

@freezed
class SocialEntry with _$SocialEntry {
  const factory SocialEntry(
    Uri link,
    SocialEntryType type,
  ) = _SocialEntry;

  factory SocialEntry.fromJson(Map<String, dynamic> json) =>
      _$SocialEntryFromJson(json);
}
