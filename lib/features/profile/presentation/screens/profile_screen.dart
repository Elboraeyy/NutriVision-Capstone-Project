import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_green_header.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocListener<AuthSessionBloc, AuthSessionState>(
        listener: (context, state) {
          if (state.status == AuthSessionStatus.signedOut) {
            AppToast.show(
              context,
              message: 'You have been logged out.',
              type: AppToastType.success,
            );
            context.go('/sign-in');
          }
        },
        child: AppOverlayScaffold(
          header: AppGreenHeader(
            title: 'Profile',
            subtitle: 'Keep your NutriVision journey in your hands.',
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(
              AppResponsive.value(context, 20),
              AppOverlayScaffold.contentTop(context, 175) +
                  AppResponsive.value(context, 24),
              AppResponsive.value(context, 20),
              AppResponsive.value(context, 20),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: AppActionButton(
                label: 'Log out',
                onPressed: () {
                  context.read<AuthSessionBloc>().add(const SignOutRequested());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
