import 'package:commercio/state/editing/editing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget errorWidget(Object object, StackTrace stackTrace) {
  debugPrint(object.toString());
  debugPrint(stackTrace.toString());
  return Text(
    'Error: $object',
    style: const TextStyle(color: Colors.red),
  );
}

Widget loadingWidget({Size? size}) {
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
  });

  final bool Function()? onEditingComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editingProvider);
    return IconButton(
      onPressed: isEditing
          ? () {
              if (onEditingComplete?.call() ?? false) {
                ref.read(editingProvider.notifier).toggle();
              }
            }
          : () {
              ref.read(editingProvider.notifier).toggle();
            },
      icon: isEditing ? const Icon(Icons.edit_off) : const Icon(Icons.edit),
    );
  }
}
