import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/config/supabase_config.dart';
import '../../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(SupabaseConfig.client);
});

final authStateProvider = StreamProvider<supabase.AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

final currentUserProvider = Provider<supabase.User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState != null) {
    return authState.session?.user;
  }
  return ref.watch(authRepositoryProvider).currentUser;
});

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Watch to ensure the provider is initialized and we listen to its changes if any
    ref.watch(authRepositoryProvider);
  }

  Future<void> signIn(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.signIn(email, password));
  }

  Future<void> signUp(String email, String password, String fullName) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.signUp(email, password, fullName));
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.signOut());
  }

  Future<void> resetPassword(String email) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.resetPassword(email));
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});
