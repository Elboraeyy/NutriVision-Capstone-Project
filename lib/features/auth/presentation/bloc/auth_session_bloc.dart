import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

enum AuthSessionStatus { signedOut, loading, signedIn, failure }

class AuthSessionState {
  const AuthSessionState({
    this.status = AuthSessionStatus.signedOut,
    this.user,
    this.message,
  });

  final AuthSessionStatus status;
  final AuthUser? user;
  final String? message;

  AuthSessionState copyWith({
    AuthSessionStatus? status,
    AuthUser? user,
    String? message,
    bool clearUser = false,
  }) {
    return AuthSessionState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      message: message,
    );
  }
}

abstract class AuthSessionEvent {
  const AuthSessionEvent();
}

class SignInRequested extends AuthSessionEvent {
  const SignInRequested({required this.email, required this.password});

  final String email;
  final String password;
}

class SignUpRequested extends AuthSessionEvent {
  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class SignOutRequested extends AuthSessionEvent {
  const SignOutRequested();
}

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  AuthSessionBloc({
    required AuthRepository repository,
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       super(AuthSessionState(user: repository.currentUser)) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    emit(state.copyWith(status: AuthSessionStatus.loading, message: null));
    try {
      final user = await _signIn(email: event.email, password: event.password);
      emit(
        state.copyWith(
          status: AuthSessionStatus.signedIn,
          user: user,
          message: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthSessionStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    emit(state.copyWith(status: AuthSessionStatus.loading, message: null));
    try {
      final user = await _signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: AuthSessionStatus.signedIn,
          user: user,
          message: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthSessionStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    await _signOut();
    emit(const AuthSessionState());
  }
}
