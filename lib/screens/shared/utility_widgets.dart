import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/social_entry/social_entry.dart';
import 'package:commercio/repositories/generic_repository.dart';
import 'package:commercio/state/editing/editing.dart';
import 'package:commercio/state/locale.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

Widget errorWidget(Object object, StackTrace stackTrace) {
  debugPrint(object.toString());
  debugPrint(stackTrace.toString());
  return Center(
    child: Text(
      'Error: $object',
      style: const TextStyle(color: Colors.red),
    ),
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
    final t = ref.watch(translationProvider).translations.general;
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
      tooltip: t.editButtonToolTipText,
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

class FirestoreSliverList<T extends BaseEntity> extends ConsumerWidget {
  const FirestoreSliverList({
    super.key,
    required this.collectionPath,
    required this.fromJson,
    required this.builder,
  });

  final String collectionPath;
  final T Function(Map<String, dynamic> json) fromJson;
  final Widget Function(
    BuildContext context,
    int index,
    List<T> entites,
  ) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FirestoreQueryBuilder<T>(
      query: FirebaseFirestore.instance
          .collection(
            collectionPath,
          )
          .withConverter(
            fromFirestore: (json, _) => fromJson(json.data()!),
            toFirestore: (entity, __) => entity.toJson(),
          ),
      builder: (context, snapshot, child) {
        if (snapshot.isFetching) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Text('error ${snapshot.error}'),
          );
        }
        final docs = snapshot.docs;
        if (docs.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Lottie.asset('assets/lottiefiles/empty.json'),
            ),
          );
        }
        final entities = docs.map((e) => e.data()).toList();
        return SliverList.builder(
          itemBuilder: (context, index) {
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              snapshot.fetchMore();
            }

            return builder(context, index, entities);
          },
          itemCount: entities.length,
        );
      },
    );
  }
}
