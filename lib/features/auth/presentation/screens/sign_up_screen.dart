import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../cubit/sign_up_cubit.dart';
import '../utils/auth_validation.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController(text: 'Maya');
  final _emailController = TextEditingController(text: 'maya@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _confirmPasswordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount(BuildContext context, SignUpState state) {
    final emailError = AuthValidation.isValidEmail(_emailController.text)
        ? null
        : 'Please enter a valid email.';
    final passwordError = _passwordController.text.length < 8
        ? 'Password must be at least 8 characters.'
        : null;
    final confirmError =
        _passwordController.text == _confirmPasswordController.text
        ? null
        : 'Passwords do not match.';

    final error = !state.isTermsAccepted
        ? 'Please accept the Terms of Service and Privacy Policy.'
        : emailError ?? passwordError ?? confirmError;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account form is ready for Firebase integration.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Column(
          children: [
            const AuthHeader(
              title: 'A fresh start, for you.',
              subtitle: 'Create your account. Make room for better habits.',
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.value(context, 18),
                  AppResponsive.value(context, 18),
                  AppResponsive.value(context, 18),
                  0,
                ),
                child: BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) {
                    return CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthField(
                                label: 'Name',
                                controller: _nameController,
                                suffixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.green,
                                  size: 17,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AuthField(
                                label: 'Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                suffixIcon: const Icon(
                                  Icons.check,
                                  color: AppColors.green,
                                  size: 17,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AuthField(
                                label: 'Password',
                                controller: _passwordController,
                                obscureText: !state.isPasswordVisible,
                                onToggleObscure: context
                                    .read<SignUpCubit>()
                                    .togglePasswordVisibility,
                              ),
                              const SizedBox(height: 10),
                              AuthField(
                                label: 'Confirm password',
                                controller: _confirmPasswordController,
                                obscureText: !state.isConfirmPasswordVisible,
                                onToggleObscure: context
                                    .read<SignUpCubit>()
                                    .toggleConfirmPasswordVisibility,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Use at least 8 characters with a letter and a number.',
                                style: TextStyle(
                                  color: AppColors.mutedGreen,
                                  fontSize: 9,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.green,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _passwordController.text ==
                                                _confirmPasswordController
                                                    .text &&
                                            _passwordController.text.isNotEmpty
                                        ? "Passwords match. You're ready to go."
                                        : 'Passwords must match.',
                                    style: const TextStyle(
                                      color: AppColors.mutedGreen,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: context.read<SignUpCubit>().toggleTerms,
                                child: Row(
                                  children: [
                                    Icon(
                                      state.isTermsAccepted
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: state.isTermsAccepted
                                          ? AppColors.green
                                          : AppColors.borderGreen,
                                      size: 19,
                                    ),
                                    const SizedBox(width: 5),
                                    const Expanded(
                                      child: Text(
                                        'I agree to the Terms of Service and Privacy Policy.',
                                        style: TextStyle(
                                          color: AppColors.mutedGreen,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Personal details come later, and they’re optional.',
                                style: TextStyle(
                                  color: AppColors.mutedGreen,
                                  fontSize: 9,
                                ),
                              ),
                              const Spacer(),
                              AuthActionButton(
                                label: 'Create account',
                                onPressed: () => _createAccount(context, state),
                              ),
                              const SizedBox(height: 11),
                              GestureDetector(
                                onTap: () => context.go('/sign-in'),
                                child: const Text(
                                  'Already have an account? Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.darkGreen,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 21),
                              const _HomeIndicator(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 128,
        height: 5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
    );
  }
}
