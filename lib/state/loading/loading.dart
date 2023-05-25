import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading.g.dart';

@Riverpod(keepAlive: false)
FutureOr<void> loadingFuture(LoadingFutureRef ref, Duration duration) async {
  return await Future.delayed(duration);
}
