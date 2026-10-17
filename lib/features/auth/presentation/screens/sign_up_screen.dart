import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_green_header.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/auth_session_bloc.dart';
import '../cubit/sign_up_cubit.dart';
import '../../../onboarding/presentation/bloc/onboarding_bloc.dart';
import '../utils/auth_validation.dart';
import '../widgets/auth_underlined_text.dart';

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
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_refreshFormFeedback);
    _confirmPasswordController.addListener(_refreshFormFeedback);
    _passwordFocusNode.addListener(_refreshFormFeedback);
    _confirmPasswordFocusNode.addListener(_refreshFormFeedback);
  }

  void _refreshFormFeedback() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool get _passwordHasText => _passwordController.text.isNotEmpty;

  bool get _confirmPasswordHasText =>
      _confirmPasswordController.text.isNotEmpty;

  bool get _passwordsMatch =>
      _passwordHasText &&
      _confirmPasswordHasText &&
      _passwordController.text == _confirmPasswordController.text;

  Future<void> _createAccount(BuildContext context) async {
    final formState = context.read<SignUpCubit>().state;
    final error = AuthValidation.validateSignUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      termsAccepted: formState.isTermsAccepted,
    );
    if (error != null) {
      AppToast.show(context, message: error, type: AppToastType.error);
      return;
    }

    context.read<AuthSessionBloc>().add(
      SignUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.greenHeader,
        child: BlocListener<AuthSessionBloc, AuthSessionState>(
          listener: (context, state) {
            if (state.status == AuthSessionStatus.signedIn) {
              AppToast.show(
                context,
                message: 'Account created. Let’s personalize your plan.',
                type: AppToastType.success,
              );
              context.read<OnboardingBloc>().add(const OnboardingReset());
              context.pushNamed('onboarding-goal');
            } else if (state.status == AuthSessionStatus.failure) {
              AppToast.show(
                context,
                message: state.message ?? 'Unable to create account.',
                type: AppToastType.error,
              );
            }
          },
          child: AppOverlayScaffold(
            header: AppGreenHeader(
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
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 16),
                0,
                AppResponsive.value(context, 18),
                0,
              ),
              child: BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top:
                              AppOverlayScaffold.contentTop(context, 175) +
                              AppResponsive.value(context, 18),
                        ),
                        sliver: SliverFillRemaining(
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
                              SizedBox(height: AppResponsive.value(context, 2)),
                              AppTextField(
                                label: 'Email',
                                hintText: 'mohamed@example.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                suffixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: AppColors.green,
                                  size: 17,
                                ),
                              ),
                              SizedBox(height: AppResponsive.value(context, 2)),
                              AppTextField(
                                label: 'Password',
                                hintText: '••••••••••••',
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                obscureText: !state.isPasswordVisible,
                                onToggleObscure: context
                                    .read<SignUpCubit>()
                                    .togglePasswordVisibility,
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                child:
                                    _passwordFocusNode.hasFocus ||
                                        _passwordHasText
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: AppResponsive.value(context, 6),
                                          left: AppResponsive.value(context, 4),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              AuthValidation.isValidPassword(
                                                    _passwordController.text,
                                                  )
                                                  ? Icons.check_circle_outline
                                                  : Icons.info_outline,
                                              color: AppColors.mutedGreen,
                                              size: AppResponsive.value(
                                                context,
                                                15,
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppResponsive.value(
                                                context,
                                                5,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                AuthValidation.isValidPassword(
                                                      _passwordController.text,
                                                    )
                                                    ? 'Password meets the requirements.'
                                                    : 'Use at least 8 characters with a letter and a number.',
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
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              SizedBox(height: AppResponsive.value(context, 2)),
                              AppTextField(
                                label: 'Confirm password',
                                hintText: '••••••••••••',
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,
                                obscureText: !state.isConfirmPasswordVisible,
                                onToggleObscure: context
                                    .read<SignUpCubit>()
                                    .toggleConfirmPasswordVisibility,
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                child: _confirmPasswordHasText
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: AppResponsive.value(context, 6),
                                          left: AppResponsive.value(context, 4),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              _passwordsMatch
                                                  ? Icons.check_circle_outline
                                                  : Icons.info_outline,
                                              color: _passwordsMatch
                                                  ? AppColors.green
                                                  : AppColors.mutedGreen,
                                              size: AppResponsive.value(
                                                context,
                                                15,
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppResponsive.value(
                                                context,
                                                5,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                _passwordsMatch
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
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              SizedBox(height: AppResponsive.value(context, 5)),
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
                              const Spacer(),
                              SizedBox(height: AppResponsive.value(context, 7)),
                              Center(
                                child: Text(
                                  'Personal details come later, and they’re optional.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.mutedGreen,
                                    fontSize: AppResponsive.font(context, 12),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppResponsive.value(context, 7)),
                              AppActionButton(
                                label: 'Create account',
                                onPressed: () => _createAccount(context),
                              ),
                              SizedBox(
                                height: AppResponsive.value(context, 12),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () => context.go('/sign-in'),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                          color: AppColors.darkGreen,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      const AuthUnderlinedText(text: 'Sign In'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppResponsive.value(context, 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
