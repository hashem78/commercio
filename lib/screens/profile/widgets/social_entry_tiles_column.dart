import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/screens/profile/widgets/social_entry_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SocialEntryTilesColumn extends HookConsumerWidget {
  const SocialEntryTilesColumn({
    super.key,
    required this.entries,
  });
  final List<SocialEntry> entries;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: entries.map((e) => SocialEntryTile(entry: e)).toList(),
    );
  }
}
