import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_widgets.dart';

/// Main Profile & Settings screen matching Figma node 206:6091.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double _headerHeight = 165;

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(context, _headerHeight);
    final overlap = AppResponsive.value(context, 24);
    final identityCardHeight = AppResponsive.value(context, 96);

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
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            final authUserName = context.select(
              (AuthSessionBloc bloc) => bloc.state.user?.name,
            );
            final displayName = authUserName?.trim().isNotEmpty == true
                ? authUserName!.trim()
                : profileState.profile.displayName;

            return AppOverlayScaffold(
              header: const ProfileHeader(
                title: 'Profile & settings.',
                subtitle: 'Your nutrition, your way.',
                height: _headerHeight,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.value(context, 20),
                  headerHeight +
                      identityCardHeight -
                      overlap +
                      AppResponsive.value(context, 20),
                  AppResponsive.value(context, 20),
                  AppResponsive.value(context, 112),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account settings',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 16),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 10)),
                    ProfileCard(
                      child: Column(
                        children: [
                          ProfileSettingsOptionRow(
                            icon: Icons.tune_rounded,
                            title: 'Goals & Dietary Preferences',
                            subtitle: 'Daily targets, allergies & food choices',
                            onTap: () => context.pushNamed('profile-goals'),
                          ),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          const ProfileDivider(),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          ProfileSettingsOptionRow(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications Settings',
                            subtitle: 'Meal logging & water reminders',
                            onTap: () =>
                                context.pushNamed('profile-notifications'),
                          ),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          const ProfileDivider(),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          ProfileSettingsOptionRow(
                            icon: Icons.verified_user_outlined,
                            title: 'Privacy & Data Management',
                            subtitle: 'Your diary, data options & AI',
                            onTap: () => context.pushNamed('profile-privacy'),
                          ),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          const ProfileDivider(),
                          SizedBox(height: AppResponsive.value(context, 12)),
                          ProfileSettingsOptionRow(
                            icon: Icons.logout_rounded,
                            iconBackgroundColor: kProfileSignOutBg,
                            iconColor: kProfileSignOutRed,
                            title: 'Sign out',
                            titleColor: kProfileSignOutRed,
                            subtitle: 'Sign out of your account',
                            subtitleColor: kProfileSignOutRed.withValues(
                              alpha: 0.7,
                            ),
                            showChevron: false,
                            onTap: () => _handleSignOutTap(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              foregrounds: [
                Positioned(
                  top: headerHeight - overlap,
                  left: AppResponsive.value(context, 20),
                  right: AppResponsive.value(context, 20),
                  child: ProfileUserIdentityCard(
                    name: displayName,
                    subtitle: profileState.profile.subtitle,
                  ),
                ),
                const ProfileBottomNav(isRootProfile: true),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleSignOutTap(BuildContext context) async {
    final confirmed = await SignOutConfirmationDialog.show(context);
    if (!confirmed || !context.mounted) return;
    context.read<AuthSessionBloc>().add(const SignOutRequested());
  }
}
