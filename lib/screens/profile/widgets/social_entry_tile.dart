import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SocialEntryTile extends HookConsumerWidget {
  const SocialEntryTile({
    super.key,
    required this.entry,
  });

  final SocialEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider).translations.profile;

    return ListTile(
      onTap: () async {
        try {
          await launchUrl(entry.link, mode: LaunchMode.externalApplication);
        } on PlatformException {
          await launchUrlString(
            entry.link.toString(),
            mode: LaunchMode.externalApplication,
          );
        }
      },
      leading: socialIconFromEntryType(entry.type),
      title: Text(t.link),
    );
  }
}
