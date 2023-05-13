import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/models/user/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
Stream<SUser> user(Ref ref, {required String userId}) async* {
  final db = FirebaseFirestore.instance;
  await for (final snapshot in db.collection('users').doc(userId).snapshots()) {
    if (!snapshot.exists) continue;
    final data = snapshot.data();
    if (data == null) continue;
    await Future.delayed(const Duration(seconds: 1));
    yield SUser.fromJson(data);
  }
}
