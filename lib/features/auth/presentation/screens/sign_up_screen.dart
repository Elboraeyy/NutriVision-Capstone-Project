import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_green_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/sign_up_cubit.dart';
import '../utils/auth_validation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.greenHeader,
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                AppGreenHeader(
                  title: 'A fresh start, for you.',
                  subtitle: 'Create your account. Make room for better habits.',
                  eyebrow: 'YOUR ACCOUNT',
                  onBack: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/welcome');
                    }
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.value(context, 16),
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
                                  AppTextField(
                                    label: 'Name',
                                    hintText: 'Mohamed',
                                    controller: _nameController,
                                    suffixIcon: const Icon(
                                      Icons.person_outline,
                                      color: AppColors.green,
                                      size: 17,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 2),
                                  ),
                                  AppTextField(
                                    label: 'Email',
                                    hintText: 'mohamed@example.com',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    suffixIcon: const Icon(
                                      Icons.check,
                                      color: AppColors.green,
                                      size: 17,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 2),
                                  ),
                                  AppTextField(
                                    label: 'Password',
                                    hintText: '••••••••••••',
                                    controller: _passwordController,
                                    obscureText: !state.isPasswordVisible,
                                    onToggleObscure: context
                                        .read<SignUpCubit>()
                                        .togglePasswordVisibility,
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 2),
                                  ),
                                  AppTextField(
                                    label: 'Confirm password',
                                    hintText: '••••••••••••',
                                    controller: _confirmPasswordController,
                                    obscureText:
                                        !state.isConfirmPasswordVisible,
                                    onToggleObscure: context
                                        .read<SignUpCubit>()
                                        .toggleConfirmPasswordVisibility,
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 5),
                                  ),
                                  Text(
                                    'Use at least 8 characters with a letter and a number.',
                                    style: TextStyle(
                                      color: AppColors.mutedGreen,
                                      fontSize: AppResponsive.font(context, 12),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 5),
                                  ),
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
                                                _passwordController
                                                    .text
                                                    .isNotEmpty
                                            ? "Passwords match. You're ready to go."
                                            : 'Passwords must match.',
                                        style: TextStyle(
                                          color: AppColors.mutedGreen,
                                          fontSize: AppResponsive.font(
                                            context,
                                            12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 5),
                                  ),
                                  GestureDetector(
                                    onTap: context
                                        .read<SignUpCubit>()
                                        .toggleTerms,
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
                                        Expanded(
                                          child: Text(
                                            'I agree to the Terms of Service and Privacy Policy.',
                                            style: TextStyle(
                                              color: AppColors.mutedGreen,
                                              fontSize: AppResponsive.font(
                                                context,
                                                12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 7),
                                  ),
                                  Text(
                                    'Personal details come later, and they’re optional.',
                                    style: TextStyle(
                                      color: AppColors.mutedGreen,
                                      fontSize: AppResponsive.font(context, 12),
                                    ),
                                  ),
                                  const Spacer(),
                                  AppActionButton(
                                    label: 'Create account',
                                    onPressed: () =>
                                        _createAccount(context, state),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 12),
                                  ),
                                  GestureDetector(
                                    onTap: () => context.go('/sign-in'),
                                    child: const Text(
                                      'Already have an account? Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 18),
                                  ),
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
        ),
      ),
    );
  }
}
