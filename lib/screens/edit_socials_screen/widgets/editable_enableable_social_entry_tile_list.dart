import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/edit_socials_screen/widgets/editable_enableable_social_entry_tile.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditableEnableableSocialEntryTileList extends HookConsumerWidget {
  final String userId;
  const EditableEnableableSocialEntryTileList({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    final user = ref.watch(userStreamProvider(userId)).value!;

    return Column(
      children: SocialEntryType.values
          .map(
            (entryType) => EditableEnableableSocialEntryTile(
              entryType: entryType,
              userEntryMap: user.socialEntriesMap,
              oldLink: user.socialEntriesMap[entryType]?.link.toString(),
              onEdit: (selectedEntry, selectedEntryLink) async {
                if (!isMounted()) return;

                await EditSocialsDialogRoute(
                  userId: user.id,
                  $extra: (selectedEntry, selectedEntryLink ?? ''),
                ).push(context);
              },
            ),
          )
          .toList(),
    );
  }
}
