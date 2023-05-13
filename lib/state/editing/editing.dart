import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editing.g.dart';

@riverpod
class Editing extends _$Editing {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
