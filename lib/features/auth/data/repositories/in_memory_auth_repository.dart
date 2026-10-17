import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Temporary repository used until Firebase authentication is connected.
class InMemoryAuthRepository implements AuthRepository {
  AuthUser? _currentUser;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _currentUser = AuthUser(
      id: email.toLowerCase(),
      name: name,
      email: email.toLowerCase(),
    );
    return _currentUser!;
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    _currentUser = AuthUser(
      id: email.toLowerCase(),
      name: 'Maya',
      email: email.toLowerCase(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
