import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_green_header.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/auth_session_bloc.dart';
import '../cubit/sign_in_cubit.dart';
import '../utils/auth_validation.dart';
import '../widgets/auth_underlined_text.dart';

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

  Future<void> _signIn(BuildContext context) async {
    final error = AuthValidation.validateSignIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (error != null) {
      AppToast.show(context, message: error, type: AppToastType.error);
      return;
    }

    context.read<AuthSessionBloc>().add(
      SignInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.greenHeader,
        child: BlocListener<AuthSessionBloc, AuthSessionState>(
          listener: (context, state) {
            if (state.status == AuthSessionStatus.signedIn) {
              AppToast.show(
                context,
                message:
                    'Welcome back${state.user?.name == null ? '' : ', ${state.user!.name}'}!',
                type: AppToastType.success,
              );
              context.go('/splash?destination=home');
            } else if (state.status == AuthSessionStatus.failure) {
              AppToast.show(
                context,
                message: state.message ?? 'Unable to sign in.',
                type: AppToastType.error,
              );
            }
          },
          child: AppOverlayScaffold(
            header: AppGreenHeader(
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
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 18),
                0,
                AppResponsive.value(context, 18),
                0,
              ),
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top:
                          AppOverlayScaffold.contentTop(context, 175) +
                          AppResponsive.value(context, 22),
                    ),
                    sliver: SliverFillRemaining(
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
                                  AppToast.show(
                                    context,
                                    message: 'Enter your email first.',
                                    type: AppToastType.warning,
                                  );
                                  return;
                                }
                                AppToast.show(
                                  context,
                                  message:
                                      'Password reset will be available soon.',
                                  type: AppToastType.info,
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.darkGreen,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const AuthUnderlinedText(
                                text: 'Forgot password?',
                              ),
                            ),
                          ),
                          const Spacer(),
                          AppActionButton(
                            label: 'Sign In',
                            onPressed: () => _signIn(context),
                          ),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          Center(
                            child: GestureDetector(
                              onTap: () => context.push('/sign-up'),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'New to NutriVision?',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const AuthUnderlinedText(text: 'Sign Up'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppResponsive.value(context, 18)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
