import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

String? unauthorizedRedirect(BuildContext context, String userId) {
  final providerContainer = ProviderScope.containerOf(context);
  final authedUser = providerContainer.read(authStreamProvider).value!;
  if (authedUser.uid == userId) return null;

  return '/profile/$userId';
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
