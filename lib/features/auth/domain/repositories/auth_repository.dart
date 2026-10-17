import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  AuthUser? get currentUser;

  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthUser> signIn({required String email, required String password});

  Future<void> signOut();
}
