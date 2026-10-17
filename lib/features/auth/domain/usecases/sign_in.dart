import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  const SignIn(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
