import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/sign_in_cubit.dart';
import '../utils/auth_validation.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_header.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController(text: 'maya@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Column(
          children: [
            const AuthHeader(
              title: 'Good to see you again.',
              subtitle: 'Your food, your goals, your everyday balance.',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: const Icon(
                        Icons.mail_outline,
                        color: AppColors.green,
                        size: 17,
                      ),
                    ),
                    const SizedBox(height: 14),
                    BlocBuilder<SignInCubit, SignInState>(
                      builder: (context, state) {
                        return AuthField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: !state.isPasswordVisible,
                          onToggleObscure: context
                              .read<SignInCubit>()
                              .togglePasswordVisibility,
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (!AuthValidation.isValidEmail(
                            _emailController.text,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enter your email first.'),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password reset will be connected with Firebase.',
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.darkGreen,
                          padding: const EdgeInsets.only(top: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    AuthActionButton(
                      label: 'Sign In',
                      onPressed: () {
                        final error = AuthValidation.validateSignIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error ??
                                  'Sign in is ready for Firebase integration.',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 11),
                    GestureDetector(
                      onTap: () => context.push('/sign-up'),
                      child: const Text(
                        'New to NutriVision? Sign Up',
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
                  ],
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
