import 'package:flutter_bloc/flutter_bloc.dart';

class SignInState {
  const SignInState({this.isPasswordVisible = false});

  final bool isPasswordVisible;

  SignInState copyWith({bool? isPasswordVisible}) {
    return SignInState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}
