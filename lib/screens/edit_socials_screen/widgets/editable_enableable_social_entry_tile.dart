import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
