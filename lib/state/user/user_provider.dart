import 'package:commercio/models/user/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
SUser currentUser(Ref ref) =>
    throw UnimplementedError('Override currentUserProvider');
