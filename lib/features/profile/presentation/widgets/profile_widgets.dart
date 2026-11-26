import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';

const Color kProfileCardSurface = Color(0xFFEDF0E1);
const Color kProfileDividerColor = Color(0xFFCAD5BF);
const Color kProfileSignOutRed = Color(0xFFC0392B);
const Color kProfileSignOutBg = Color(0xFFF5E8E8);
const Color kProfileDeleteTextRed = Color(0xFF843E32);
const Color kProfileDeleteSurface = Color(0xFFF4E5DE);

/// Curved forest-green header used across Profile & Settings screens.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.backLabel,
    this.onBack,
    this.height = 175,
  });

  final String title;
  final String subtitle;
  final String? backLabel;
  final VoidCallback? onBack;
  final double height;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: topInset + AppResponsive.value(context, height),
      ),
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 20),
        topInset + AppResponsive.value(context, 10),
        AppResponsive.value(context, 20),
        AppResponsive.value(context, 28),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 52)),
          bottomRight: Radius.circular(AppResponsive.value(context, 52)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (backLabel != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack ?? () => context.pop(),
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppResponsive.value(context, 6),
                    horizontal: AppResponsive.value(context, 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: AppResponsive.value(context, 18),
                      ),
                      SizedBox(width: AppResponsive.value(context, 6)),
                      Text(
                        backLabel!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppResponsive.font(context, 12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.value(context, 6),
              ),
              child: Text(
                'NutriVision',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppResponsive.font(context, 15),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 27),
              fontWeight: FontWeight.w800,
              height: 1.18,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating bottom navigation bar pinned to the Profile tab.
class ProfileBottomNav extends StatelessWidget {
  const ProfileBottomNav({super.key, this.isRootProfile = false});

  final bool isRootProfile;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppResponsive.value(context, 14),
      right: AppResponsive.value(context, 14),
      bottom: AppResponsive.value(context, 8),
      child: AppFloatingNavigationBar(
        selectedIndex: 4,
        onSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/meal-plan');
            case 2:
              context.go('/discover');
            case 3:
              context.go('/progress');
            case 4:
              if (!isRootProfile) {
                context.go('/profile');
              }
          }
        },
      ),
    );
  }
}

/// Rounded settings card matching the Profile & Settings design language.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.child,
    this.backgroundColor = kProfileCardSurface,
    this.padding,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 30)),
      ),
      child: child,
    );
  }
}

/// Floating user identity card overlapping the Profile & Settings header.
class ProfileUserIdentityCard extends StatelessWidget {
  const ProfileUserIdentityCard({
    super.key,
    required this.name,
    required this.subtitle,
  });

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final avatarSize = AppResponsive.value(context, 64);

    return ProfileCard(
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              AppAssets.profileAvatar,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: avatarSize,
                height: avatarSize,
                color: AppColors.peach,
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.green,
                  size: AppResponsive.value(context, 30),
                ),
              ),
            ),
          ),
          SizedBox(width: AppResponsive.value(context, 14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
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
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 12),
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

/// Interactive row inside a Profile settings card.
class ProfileSettingsOptionRow extends StatelessWidget {
  const ProfileSettingsOptionRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.iconBackgroundColor = AppColors.softGreen,
    this.iconColor = AppColors.green,
    this.titleColor = AppColors.darkGreen,
    this.subtitleColor = AppColors.mutedGreen,
    this.trailing,
    this.showChevron = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: AppResponsive.value(context, 54)),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: AppResponsive.value(context, 36),
              height: AppResponsive.value(context, 36),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(
                  AppResponsive.value(context, 14),
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: AppResponsive.value(context, 18),
              ),
            ),
            SizedBox(width: AppResponsive.value(context, 12)),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 2)),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: AppResponsive.font(context, 11),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: AppResponsive.value(context, 8)),
            trailing!,
          ] else if (showChevron) ...[
            SizedBox(width: AppResponsive.value(context, 8)),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.darkGreen,
              size: AppResponsive.value(context, 18),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 18)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.value(context, 2),
          ),
          child: content,
        ),
      ),
    );
  }
}

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: kProfileDividerColor,
    );
  }
}

/// Sign-out confirmation modal matching Figma node 206:8432.
class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => const SignOutConfirmationDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cream,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 24),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 30)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppResponsive.value(context, 320),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.value(context, 24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign out?',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: AppResponsive.font(context, 18),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Material(
                    color: kProfileCardSurface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(false),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: AppResponsive.value(context, 28),
                        height: AppResponsive.value(context, 28),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.darkGreen,
                          size: AppResponsive.value(context, 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.value(context, 14)),
              Text(
                'You\'ll be signed out of your NutriVision account. Your data and preferences will be saved.',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 13),
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 18)),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: kProfileSignOutRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: AppResponsive.value(context, 14),
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, 14),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 8)),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    backgroundColor: kProfileCardSurface,
                    foregroundColor: AppColors.darkGreen,
                    padding: EdgeInsets.symmetric(
                      vertical: AppResponsive.value(context, 14),
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, 14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selected preference/allergen pill chip matching Figma's dark-green badge.
class ProfileSelectedChip extends StatelessWidget {
  const ProfileSelectedChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 12),
        vertical: AppResponsive.value(context, 9),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_rounded,
            color: AppColors.lime,
            size: AppResponsive.value(context, 14),
          ),
          SizedBox(width: AppResponsive.value(context, 6)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 12),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Editable daily nutrition target row (Calories, Protein, Carbs, Fat, Water).
class ProfileTargetFieldRow extends StatelessWidget {
  const ProfileTargetFieldRow({
    super.key,
    required this.label,
    required this.valueText,
    required this.unit,
    required this.pillColor,
    required this.onTap,
  });

  final String label;
  final String valueText;
  final String unit;
  final Color pillColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: AppResponsive.value(context, 44)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Material(
            color: pillColor,
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 16),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(
                AppResponsive.value(context, 16),
              ),
              child: Container(
                width: AppResponsive.value(context, 148),
                height: AppResponsive.value(context, 42),
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 12),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppResponsive.value(context, 16),
                  ),
                  border: Border.all(color: AppColors.borderGreen),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        valueText,
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 13),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      unit,
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 11),
                      ),
                    ),
                    SizedBox(width: AppResponsive.value(context, 6)),
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.mutedGreen,
                      size: AppResponsive.value(context, 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cream pill selector button used in Notifications Settings.
class ProfileSelectorPill extends StatelessWidget {
  const ProfileSelectorPill({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          constraints: BoxConstraints(
            minHeight: AppResponsive.value(context, 36),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 12),
            vertical: AppResponsive.value(context, 8),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.borderGreen),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppResponsive.value(context, 140),
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 12),
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 6)),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.darkGreen,
                size: AppResponsive.value(context, 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
