import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpState {
  const SignUpState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isTermsAccepted = false,
  });

  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAccepted;

  SignUpState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isTermsAccepted,
  }) {
    return SignUpState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void toggleTerms() {
    emit(state.copyWith(isTermsAccepted: !state.isTermsAccepted));
  }
}
