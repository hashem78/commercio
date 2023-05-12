import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/profile_picture/profile_picture_model.dart';
import 'package:commercio/models/user/user_model.dart';
import 'package:commercio/router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The notifier for when the auth state changes
/// to be used by authProvider.
class AuthNotifier extends StateNotifier<SUser> {
  static final auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance;

  final Ref ref;

  bool isFirstTime = false;

  /// The subscription instance to the firebase auth
  /// userChanges stream, this is for cleanup.

  StreamSubscription<User?>? subscription;
  StreamSubscription<SUser?>? psubscription;

  AuthNotifier(this.ref) : super(const SUser()) {
    subscription ??= auth.userChanges().listen(
      (event) async {
        if (event != null) {
          final userDoc = await db.doc('users/${event.uid}').get();

          if (userDoc.exists) {
            state = SUser.fromJson(userDoc.data()!);
          } else {
            final user = SUser(
              id: event.uid,
              email: event.email!,
              name: event.displayName ?? event.email!.split('@').first,
              profilePicture: SProfilePicture(
                link: event.photoURL ?? "https://i.imgur.com/qW7gjGk.jpg",
              ),
            );
            await db.doc('users/${event.uid}').set(user.toJson());
            state = user;
          }

          print('here');
          print(state);
          ref.read(routerProvider).pushReplacement('/');

          psubscription?.cancel();
          psubscription = db
              .doc(
                'users/${event.uid}',
              )
              .snapshots()
              .map(
                (event) => SUser.fromJson(event.data()!),
              )
              .listen(
            (event) {
              state = event;
            },
          );
        } else {
          print('auth listener signed out');
          state = const SUser();
          ref.read(routerProvider).pushReplacementNamed('login');
        }
      },
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    psubscription?.cancel();
    super.dispose();
  }
}

/// The provider for the AuthNotifier instance responsible
/// for handeling the firebase auth userChanges stream.
/// This provider is strictly for creating an AuthNotifier instance
/// to access the currently active user use
/// pCurrentUserPorivder, or SUserProvider to access any user
/// through their uid
final authProvider = StateNotifierProvider<AuthNotifier, SUser>(
  (ref) {
    return AuthNotifier(ref);
  },
);
