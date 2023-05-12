import 'package:commercio/state/locale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignOutTile extends ConsumerWidget {
  const SignOutTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationProvider).translations;
    return ListTile(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
      },
      leading: const Icon(Icons.logout),
      title: Text(translations.settings.signoutTitle),
    );
  }
}
