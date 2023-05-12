import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides a SharedPerferences instance to all widgets under App
/// This is done so that we don't have to await getting an instance of
/// SharedPereferemces everytime we need it.
final sharedPerferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError("Shared Pereferences have not been initilalized");
});