import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/profile_picture/picture.dart';
import 'package:commercio/models/user/user_model.dart';
import 'package:commercio/screens/shared/drawer/drawer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> authStream(AuthStreamRef ref) async* {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  await for (final event in auth.authStateChanges()) {
    ref.invalidate(drawerIndexProvider);
    if (event == null) {
      yield null;
    } else {
      final doc = await db.collection('users').doc(event.uid).get();

      if (!doc.exists) {
        final user = SUser(
          id: event.uid,
          email: event.email!,
          name: event.displayName ?? event.email!.split('@').first,
          profilePicture: SPicture(
            link: event.photoURL ?? "https://i.imgur.com/qW7gjGk.jpg",
          ),
        );
        await db.doc('users/${event.uid}').set(user.toJson());
      }
      yield event;
    }
  }
}

@Riverpod(keepAlive: true)
Stream<SUser> userStream(UserStreamRef ref, String uid) async* {
  final db = FirebaseFirestore.instance;
  final docSnaps = db.collection('users').doc(uid).snapshots();

  await for (final snap in docSnaps) {
    if (!snap.exists) continue;
    yield SUser.fromJson(snap.data()!);
  }
}
