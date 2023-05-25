import 'package:commercio/models/social_entry/social_entry.dart';

import 'package:commercio/router/router.dart';
import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/auth.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

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

typedef SelectedEntryAddCallback = void Function(
  SocialEntryType selectedEntry,
  String? selectedEntryLink,
);

typedef SelectedEntryRemoveCallback = void Function(
  SocialEntryType selectedEntry,
);

class EditableEnableableSocialEntryTile extends HookConsumerWidget {
  final SocialEntryType entryType;
  final String? oldLink;
  final Map<SocialEntryType, SocialEntry> userEntryMap;
  final SelectedEntryAddCallback? onEdit;

  const EditableEnableableSocialEntryTile({
    super.key,
    required this.entryType,
    required this.userEntryMap,
    this.oldLink,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryIsUsed = userEntryMap.containsKey(entryType);

    Widget? subTitle;
    if (entryIsUsed == true) {
      subTitle = Text(userEntryMap[entryType]!.link.toString());
    }

    return CheckboxListTile(
      value: entryIsUsed,
      title: Text(toBeginningOfSentenceCase(entryType.name)!),
      subtitle: subTitle,
      secondary: socialIconFromEntryType(entryType),
      onChanged: (val) {
        onEdit?.call(entryType, oldLink);
      },
    );
  }
}
