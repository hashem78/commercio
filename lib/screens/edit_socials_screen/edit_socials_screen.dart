import 'package:commercio/screens/edit_socials_screen/widgets/editable_enableable_social_entry_tile_list.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditSocialsScreen extends ConsumerWidget {
  final String userId;
  const EditSocialsScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.editSocials;

    return SScaffold.drawerLess(
      appBarSize: AppBarSize.medium,
      title: Text(t.title),
      children: [
        EditableEnableableSocialEntryTileList(userId: userId),
      ],
    );
  }
}
