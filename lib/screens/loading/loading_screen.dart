import 'package:commercio/state/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingScreen extends ConsumerWidget {
  final Duration? duration;
  const LoadingScreen({super.key, this.duration});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (duration != null) {
      ref.listen(
        loadingFutureProvider(duration!),
        (_, next) {
          next.whenData(
            (_) {
              context.pop();
            },
          );
        },
      );
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
