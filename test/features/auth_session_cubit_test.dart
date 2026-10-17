import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_in.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_out.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_up.dart';
import 'package:nutrivision_capstone_project/features/auth/presentation/bloc/auth_session_bloc.dart';

void main() {
  test('sign up updates the shared auth session', () async {
    final repository = InMemoryAuthRepository();
    final bloc = AuthSessionBloc(
      repository: repository,
      signIn: SignIn(repository),
      signUp: SignUp(repository),
      signOut: SignOut(repository),
    );
    addTearDown(bloc.close);

    final signedIn = bloc.stream.firstWhere(
      (state) => state.status == AuthSessionStatus.signedIn,
    );
    bloc.add(
      const SignUpRequested(
        name: 'Maya',
        email: 'maya@example.com',
        password: 'Password1',
      ),
    );
    final state = await signedIn;

    expect(state.status, AuthSessionStatus.signedIn);
    expect(state.user?.email, 'maya@example.com');
  });
}
