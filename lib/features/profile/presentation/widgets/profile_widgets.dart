import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';
import '../../domain/entities/user_profile.dart';

/// Green rounded header for the Profile & Settings screen.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  static const double baseHeight = 165;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height: topInset + AppResponsive.value(context, baseHeight),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 22),
        topInset + AppResponsive.value(context, 14),
        AppResponsive.value(context, 22),
        AppResponsive.value(context, 24),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 38)),
          bottomRight: Radius.circular(AppResponsive.value(context, 38)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NutriVision',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 14),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Text(
            'Profile & settings.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 28),
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Your nutrition, your way.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating profile card displaying the user's avatar, name, and subtitle.
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({super.key, required this.profile});

  static const double baseHeight = 98;
  static const double overlapOffset = 36;

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final avatarSize = AppResponsive.value(context, 64);

    return Container(
      constraints: BoxConstraints(
        minHeight: AppResponsive.value(context, baseHeight),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 18),
        vertical: AppResponsive.value(context, 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      child: Row(
        children: [
          Semantics(
            label: '${profile.name} profile avatar',
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: AppColors.peach,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkGreen, width: 1.5),
              ),
              child: ClipOval(
                child: profile.avatarAsset != null
                    ? Image.asset(
                        profile.avatarAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _AvatarFallback(
                          size: AppResponsive.value(context, 34),
                        ),
                      )
                    : _AvatarFallback(size: AppResponsive.value(context, 34)),
              ),
            ),
          ),
          SizedBox(width: AppResponsive.value(context, 18)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 24),
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 4)),
                Text(
                  profile.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.person_rounded, color: AppColors.green, size: size),
    );
  }
}

/// Configuration for a single row inside the Account Settings card.
class ProfileSettingsOption {
  const ProfileSettingsOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.showTrailingArrow = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showTrailingArrow;
}

/// Account settings section with rounded container and separated rows.
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key, required this.options});

  final List<ProfileSettingsOption> options;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(height: AppResponsive.value(context, 12)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 24),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var index = 0; index < options.length; index++) ...[
                _AccountSettingsRow(option: options[index]),
                if (index < options.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: AppResponsive.value(context, 18),
                    endIndent: AppResponsive.value(context, 18),
                    color: AppColors.borderGreen.withValues(alpha: .55),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountSettingsRow extends StatelessWidget {
  const _AccountSettingsRow({required this.option});

  final ProfileSettingsOption option;

  @override
  Widget build(BuildContext context) {
    final titleColor = option.isDestructive
        ? AppColors.errorRed
        : AppColors.darkGreen;
    final subtitleColor = option.isDestructive
        ? AppColors.errorRed.withValues(alpha: .85)
        : AppColors.mutedGreen;
    final badgeBackground = option.isDestructive
        ? AppColors.errorRed.withValues(alpha: .12)
        : AppColors.borderGreen.withValues(alpha: .35);
    final badgeSize = AppResponsive.value(context, 42);

    return Semantics(
      button: true,
      label: option.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: option.onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(context, 18),
              vertical: AppResponsive.value(context, 16),
            ),
            child: Row(
              children: [
                Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: badgeBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option.icon,
                    color: titleColor,
                    size: AppResponsive.value(context, 20),
                  ),
                ),
                SizedBox(width: AppResponsive.value(context, 14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: AppResponsive.font(context, 14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppResponsive.value(context, 3)),
                      Text(
                        option.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: AppResponsive.font(context, 11),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                if (option.showTrailingArrow) ...[
                  SizedBox(width: AppResponsive.value(context, 8)),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.darkGreen,
                    size: AppResponsive.value(context, 20),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Confirmation dialog shown before signing the user out.
///
/// Returns `true` only when the session was already signed out and the caller
/// should navigate directly; otherwise `AuthSessionBloc` listeners handle
/// post-sign-out navigation.
Future<bool> showSignOutConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => const SignOutConfirmationDialog(),
  );
  return result ?? false;
}

class SignOutConfirmationDialog extends StatefulWidget {
  const SignOutConfirmationDialog({super.key});

  @override
  State<SignOutConfirmationDialog> createState() =>
      _SignOutConfirmationDialogState();
}

class _SignOutConfirmationDialogState extends State<SignOutConfirmationDialog> {
  bool _isSubmitting = false;

  void _handleSignOut() {
    if (_isSubmitting) return;
    final authBloc = context.read<AuthSessionBloc>();
    final alreadySignedOut =
        authBloc.state.status == AuthSessionStatus.signedOut &&
        authBloc.state.user == null;

    if (alreadySignedOut) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => _isSubmitting = true);
    authBloc.add(const SignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthSessionBloc, AuthSessionState>(
      listenWhen: (previous, current) =>
          _isSubmitting &&
          (current.status == AuthSessionStatus.signedOut ||
              current.status == AuthSessionStatus.failure),
      listener: (context, state) {
        if (!mounted) return;
        if (state.status == AuthSessionStatus.signedOut) {
          Navigator.of(context).pop(false);
          return;
        }
        if (state.status == AuthSessionStatus.failure) {
          setState(() => _isSubmitting = false);
          AppToast.show(
            context,
            message: state.message ?? 'Could not sign out. Please try again.',
            type: AppToastType.error,
          );
        }
      },
      child: PopScope(
        canPop: !_isSubmitting,
        child: Dialog(
          backgroundColor: AppColors.cream,
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 24),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 30),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppResponsive.value(context, 360),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 22),
                AppResponsive.value(context, 20),
                AppResponsive.value(context, 22),
                AppResponsive.value(context, 22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Sign out?',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 21),
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: 'Close dialog',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: const ValueKey('sign_out_dialog_close'),
                            onTap: _isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(false),
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              width: AppResponsive.value(context, 32),
                              height: AppResponsive.value(context, 32),
                              decoration: BoxDecoration(
                                color: AppColors.softGreen.withValues(
                                  alpha: 0.72,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: AppResponsive.value(context, 18),
                                color: AppColors.mutedGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.value(context, 12)),
                  Text(
                    "You'll be signed out of your NutriVision account. Your data and preferences will be saved.",
                    style: TextStyle(
                      color: AppColors.mutedGreen,
                      fontSize: AppResponsive.font(context, 13.5),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 20)),
                  SizedBox(
                    height: AppResponsive.value(context, 50),
                    child: FilledButton(
                      key: const ValueKey('sign_out_confirm_button'),
                      onPressed: _isSubmitting ? null : _handleSignOut,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        disabledBackgroundColor: AppColors.errorRed.withValues(
                          alpha: 0.72,
                        ),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign out',
                              style: TextStyle(
                                fontSize: AppResponsive.font(context, 14.5),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 10)),
                  SizedBox(
                    height: AppResponsive.value(context, 50),
                    child: TextButton(
                      key: const ValueKey('sign_out_cancel_button'),
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.softGreen.withValues(
                          alpha: 0.75,
                        ),
                        foregroundColor: AppColors.darkGreen,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: AppResponsive.font(context, 14.5),
                          fontWeight: FontWeight.w700,
                        ),
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
