import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:commercio/screens/shared/scaffold.dart';
import 'package:commercio/screens/shared/utility_widgets.dart';
import 'package:commercio/state/user/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider(userId: userId));

    final user = userAsyncValue.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    final userName = userAsyncValue.when(
      data: (user) => Text(
        user.name,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      error: errorWidget,
      loading: () => loadingWidget(const Size(100, 25)),
    );
    final email = userAsyncValue.when(
      data: (user) => Text(
        user.email,
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      error: errorWidget,
      loading: () => loadingWidget(const Size(300, 25)),
    );
    final profilePicture = userAsyncValue.when(
      data: (user) {
        return SizedBox.square(
          dimension: 250.r,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: CachedNetworkImageProvider(user.profilePicture.link),
              ),
            ),
          ),
        );
      },
      error: errorWidget,
      loading: () => SizedBox.square(
        dimension: 250.r,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: const Duration(milliseconds: 500)),
      ),
    );

    final socialEntryTiles = userAsyncValue.when(
      data: (user) => SocialEntryTiles(
        entries: user.socialEntriesMap.values.toList(),
      ),
      error: errorWidget,
      loading: loadingWidget,
    );

    return SScaffold.drawerLess(
      title: const Text('Profile'),
      appBarSize: AppBarSize.large,
      actions: [
        EditingIconButton(
          allowEditing: user != null,
          onEditingComplete: () {
            if (user == null) return false;
            return true;
          },
        ),
      ],
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    profilePicture,
                    60.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          userName,
                          email,
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                EditSocialsTile(userId: userId),
                socialEntryTiles,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditSocialsTile extends ConsumerWidget {
  const EditSocialsTile({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editingProvider);
    return ListTile(
      leading: const Icon(Icons.edit),
      onTap: () => EditSocialsRoute(userId: userId).push(context),
      enabled: isEditing,
      title: const Text('Edit Socials'),
    );
  }
}

class SocialEntryTiles extends HookConsumerWidget {
  const SocialEntryTiles({
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

class SocialEntryTile extends HookConsumerWidget {
  const SocialEntryTile({
    super.key,
    required this.entry,
  });

  final SocialEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      title: const Text('link'),
    );
  }
}
