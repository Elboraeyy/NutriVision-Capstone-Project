import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_green_header.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/sign_in_cubit.dart';
import '../utils/auth_validation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.greenHeader,
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                AppGreenHeader(
                  title: 'Good to see you again.',
                  subtitle: 'Your food, your goals, your everyday balance.',
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
                      AppResponsive.value(context, 18),
                      AppResponsive.value(context, 22),
                      AppResponsive.value(context, 18),
                      0,
                    ),
                    child: CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
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
                              SizedBox(height: AppResponsive.value(context, 9)),
                              BlocBuilder<SignInCubit, SignInState>(
                                builder: (context, state) {
                                  return AppTextField(
                                    label: 'Password',
                                    hintText: '••••••••••••',
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Enter your email first.',
                                          ),
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
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              AppActionButton(
                                label: 'Sign In',
                                onPressed: () {
                                  context.go('/welcome');
                                },
                              ),
                              SizedBox(
                                height: AppResponsive.value(context, 12),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/sign-up'),
                                child: const Text(
                                  'New to NutriVision? Sign Up',
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
