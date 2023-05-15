import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget errorWidget(Object object, StackTrace stackTrace) {
  debugPrint(object.toString());
  debugPrint(stackTrace.toString());
  return Text(
    'Error: $object',
    style: const TextStyle(color: Colors.red),
  );
}

Widget loadingWidget([Size? size]) {
  return ColoredBox(
    color: Colors.grey,
    child: SizedBox.fromSize(size: size ?? const Size(double.infinity, 25)),
  )
      .animate(onPlay: (c) => c.repeat())
      .shimmer(duration: const Duration(milliseconds: 500));
}

class EditingIconButton extends ConsumerWidget {
  const EditingIconButton({
    super.key,
    this.onEditingComplete,
    this.allowEditing = true,
  });

  final bool Function()? onEditingComplete;
  final bool allowEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editingProvider);
    final editingFunc = isEditing
        ? () {
            if (onEditingComplete?.call() ?? false) {
              ref.read(editingProvider.notifier).toggle();
            }
          }
        : () {
            ref.read(editingProvider.notifier).toggle();
          };
    return IconButton(
      onPressed: allowEditing ? editingFunc : null,
      icon: isEditing ? const Icon(Icons.edit_off) : const Icon(Icons.edit),
    );
  }
}

Widget socialIconFromEntryType(SocialEntryType entryType) {
  return FaIcon(
    switch (entryType) {
      SocialEntryType.facebook => FontAwesomeIcons.facebook,
      SocialEntryType.twitter => FontAwesomeIcons.twitter,
      SocialEntryType.whatsapp => FontAwesomeIcons.whatsapp,
      SocialEntryType.instagram => FontAwesomeIcons.instagram,
    },
  );
}
