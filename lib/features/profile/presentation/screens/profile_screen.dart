import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final user = context.read<AuthSessionBloc>().state.user;
    context.read<ProfileBloc>().add(
      ProfileRequested(userName: user?.name, userEmail: user?.email),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final shouldNavigateAlreadySignedOut = await showSignOutConfirmationDialog(
      context,
    );
    if (!shouldNavigateAlreadySignedOut || !context.mounted) return;

    AppToast.show(
      context,
      message: 'You have been logged out.',
      type: AppToastType.success,
    );
    context.goNamed('sign-in');
  }

  void _showUnavailableDestination(BuildContext context, String label) {
    AppToast.show(
      context,
      message: '$label will be connected soon.',
      type: AppToastType.info,
      duration: const Duration(milliseconds: 2000),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    if (index == 0) {
      context.read<HomeBloc>().add(const HomeTabSelected(0));
      context.goNamed('home');
      return;
    }
    if (index == 4) {
      return;
    }
    _showUnavailableDestination(context, appNavigationItems[index].label);
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(
      context,
      ProfileHeader.baseHeight,
    );
    final overlap = AppResponsive.value(
      context,
      ProfileSummaryCard.overlapOffset,
    );
    final cardHeight = AppResponsive.value(
      context,
      ProfileSummaryCard.baseHeight,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthSessionBloc, AuthSessionState>(
            listenWhen: (previous, current) =>
                previous.status != current.status ||
                previous.user?.name != current.user?.name ||
                previous.user?.email != current.user?.email,
            listener: (context, state) {
              if (state.status == AuthSessionStatus.signedOut) {
                AppToast.show(
                  context,
                  message: 'You have been logged out.',
                  type: AppToastType.success,
                );
                context.goNamed('sign-in');
                return;
              }
              context.read<ProfileBloc>().add(
                ProfileRequested(
                  userName: state.user?.name,
                  userEmail: state.user?.email,
                ),
              );
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status == ProfileStatus.failure,
            listener: (context, state) {
              AppToast.show(
                context,
                message: 'We could not load your profile. Please try again.',
                type: AppToastType.error,
              );
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final profile = state.profile;
            if (profile == null) {
              return Scaffold(
                backgroundColor: AppColors.cream,
                body: Center(
                  child: state.status == ProfileStatus.failure
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message ?? 'Unable to load your profile.',
                              style: const TextStyle(
                                color: AppColors.darkGreen,
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 12)),
                            FilledButton(
                              onPressed: _loadProfile,
                              child: const Text('Retry'),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(color: AppColors.green),
                ),
              );
            }

            final settingsOptions = [
              ProfileSettingsOption(
                icon: Icons.tune_rounded,
                title: 'Goals & Dietary Preferences',
                subtitle: 'Daily targets, allergies & food choices',
                onTap: () => context.pushNamed('goals-dietary-preferences'),
              ),
              ProfileSettingsOption(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications Settings',
                subtitle: 'Meal logging & water reminders',
                onTap: () => context.pushNamed('notifications-settings'),
              ),
              ProfileSettingsOption(
                icon: Icons.verified_user_outlined,
                title: 'Privacy & Data Management',
                subtitle: 'Your diary, data options & AI',
                onTap: () => context.pushNamed('privacy-data-management'),
              ),
              ProfileSettingsOption(
                icon: Icons.logout_rounded,
                title: 'Sign out',
                subtitle: 'Sign out of your account',
                isDestructive: true,
                showTrailingArrow: false,
                onTap: () => _handleSignOut(context),
              ),
            ];

            return AppOverlayScaffold(
              header: const ProfileHeader(),
              foreground: Positioned(
                top: headerHeight - overlap,
                left: AppResponsive.value(context, 20),
                right: AppResponsive.value(context, 20),
                child: ProfileSummaryCard(profile: profile),
              ),
              body: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            AppResponsive.value(context, 20),
                            headerHeight +
                                cardHeight -
                                overlap +
                                AppResponsive.value(context, 22),
                            AppResponsive.value(context, 20),
                            AppResponsive.value(context, 100),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              AccountSettingsSection(options: settingsOptions),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: AppResponsive.value(context, 14),
                    right: AppResponsive.value(context, 14),
                    bottom: AppResponsive.value(context, 8),
                    child: AppBottomNavBar(
                      selectedIndex: 4,
                      onSelected: (index) =>
                          _handleBottomNavTap(context, index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
