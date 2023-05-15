import 'package:commercio/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String? unauthorizedRedirect(BuildContext context, String userId) {
  final providerContainer = ProviderScope.containerOf(context);
  final authedUser = providerContainer.read(authStreamProvider).value!;
  if (authedUser.uid == userId) return null;

  return '/profile/$userId';
}
