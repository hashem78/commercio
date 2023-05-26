import 'package:commercio/router/router.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:commercio/state/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditSocialsTile extends ConsumerWidget {
  const EditSocialsTile({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editingProvider);
    final t = ref.watch(translationProvider).translations.profile;

    return ListTile(
      leading: const Icon(Icons.edit),
      onTap: () => EditSocialsRoute(userId: userId).push(context),
      enabled: isEditing,
      title: Text(t.editSocialsButtonText),
    );
  }
}
