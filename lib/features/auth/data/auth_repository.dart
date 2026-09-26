import 'package:supabase_flutter/supabase_flutter.dart';

class AppAuthException implements Exception {
  final String message;
  AppAuthException(this.message);
  @override
  String toString() => message;
}

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  User? get currentUser => _client.auth.currentUser;

  Future<void> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw AppAuthException('Failed to sign out. Please try again.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('An unexpected error occurred. Please try again.');
    }
  }
}
