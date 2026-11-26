import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';

/// Green rounded header with a back link to Profile & Settings.
class PrivacyDataHeader extends StatelessWidget {
  const PrivacyDataHeader({super.key, required this.onBack});

  static const double baseHeight = 160;
  static const double overlapDepth = 36;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height: topInset + AppResponsive.value(context, baseHeight),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 16),
        topInset + AppResponsive.value(context, 6),
        AppResponsive.value(context, 22),
        AppResponsive.value(context, 16),
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 6),
                  vertical: AppResponsive.value(context, 6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: AppResponsive.value(context, 20),
                    ),
                    SizedBox(width: AppResponsive.value(context, 6)),
                    Text(
                      'Profile & Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppResponsive.font(context, 13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Padding(
            padding: EdgeInsets.only(left: AppResponsive.value(context, 6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & data\nmanagement.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.font(context, 25),
                    fontWeight: FontWeight.w800,
                    height: 1.06,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 6)),
                Text(
                  'Understand your data and your options.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.softGreen,
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

/// Shared card surface matching the NutriVision light-green rounded cards.
class PrivacySectionCard extends StatelessWidget {
  const PrivacySectionCard({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.softGreen.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(
          color: AppColors.borderGreen.withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Top card overlapping the green header with a solid opaque background.
class ViewYourDataCard extends StatelessWidget {
  const ViewYourDataCard({super.key, required this.onOpenFoodDiary});

  final VoidCallback onOpenFoodDiary;

  @override
  Widget build(BuildContext context) {
    return PrivacySectionCard(
      backgroundColor: AppColors.softGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'View your data',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 16),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          InkWell(
            key: const ValueKey('open_food_diary_row'),
            onTap: onOpenFoodDiary,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.value(context, 4),
              ),
              child: Row(
                children: [
                  Container(
                    width: AppResponsive.value(context, 38),
                    height: AppResponsive.value(context, 38),
                    decoration: BoxDecoration(
                      color: AppColors.cream.withValues(alpha: 0.75),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.darkGreen,
                      size: AppResponsive.value(context, 20),
                    ),
                  ),
                  SizedBox(width: AppResponsive.value(context, 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open food diary',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 2)),
                        Text(
                          'View & review your logged food entries',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.darkGreen,
                    size: AppResponsive.value(context, 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for meal photo processing permission and AI usage disclosures.
class PrivacyAndAiDataCard extends StatelessWidget {
  const PrivacyAndAiDataCard({
    super.key,
    required this.allowMealPhotoProcessing,
    required this.onTogglePhotoProcessing,
  });

  final bool allowMealPhotoProcessing;
  final ValueChanged<bool> onTogglePhotoProcessing;

  @override
  Widget build(BuildContext context) {
    return PrivacySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & AI data',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 16),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allow meal photo processing',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 13),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 4)),
                    Text(
                      'Photo analysis needs your permission to send the selected photo to an AI service.',
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 12),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              Semantics(
                toggled: allowMealPhotoProcessing,
                label: 'Allow meal photo processing',
                child: Switch(
                  key: const ValueKey('meal_photo_processing_switch'),
                  value: allowMealPhotoProcessing,
                  onChanged: onTogglePhotoProcessing,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.green,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.borderGreen,
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.value(context, 12),
            ),
            child: Divider(
              height: 1,
              color: AppColors.borderGreen.withValues(alpha: 0.45),
            ),
          ),
          Text(
            'How photos are used',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'AI estimates may be inaccurate. Review foods, portions and ingredients. Retention and training use must be explained by the service before consent.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.value(context, 12),
            ),
            child: Divider(
              height: 1,
              color: AppColors.borderGreen.withValues(alpha: 0.45),
            ),
          ),
          Text(
            'Review AI estimates',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Meal recognition can be inaccurate. Always confirm nutrition values before saving a log entry.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for data export requests and permanent account deletion confirmation.
class ManageAccountDataCard extends StatelessWidget {
  const ManageAccountDataCard({
    super.key,
    required this.isExporting,
    required this.isDeletionConfirmed,
    required this.isDeleting,
    required this.onRequestDataExport,
    required this.onDeletionConfirmationChanged,
    required this.onCancelDeletion,
    required this.onConfirmDeleteAccount,
  });

  final bool isExporting;
  final bool isDeletionConfirmed;
  final bool isDeleting;
  final VoidCallback onRequestDataExport;
  final ValueChanged<bool> onDeletionConfirmationChanged;
  final VoidCallback onCancelDeletion;
  final VoidCallback onConfirmDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return PrivacySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage account data',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 16),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          InkWell(
            key: const ValueKey('request_data_export_row'),
            onTap: isExporting ? null : onRequestDataExport,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.value(context, 4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request data export',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 13),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 3)),
                        Text(
                          'Request a copy of your account and diary data.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppResponsive.value(context, 8)),
                  if (isExporting)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.green,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.darkGreen,
                      size: AppResponsive.value(context, 20),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.value(context, 12),
            ),
            child: Divider(
              height: 1,
              color: AppColors.borderGreen.withValues(alpha: 0.45),
            ),
          ),
          Text(
            'Delete account & data',
            style: TextStyle(
              color: AppColors.errorRed,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Permanently removes your account and all diary history. This cannot be undone.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppResponsive.value(context, 14)),
            decoration: BoxDecoration(
              color: AppColors.peach.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(
                AppResponsive.value(context, 18),
              ),
              border: Border.all(
                color: AppColors.errorRed.withValues(alpha: 0.18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirm deletion',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 6)),
                Text(
                  'Your diary, goals and history would be permanently lost. Confirm only if you want to delete this account.',
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 11.5),
                    height: 1.35,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 10)),
                InkWell(
                  key: const ValueKey('confirm_deletion_checkbox_row'),
                  onTap: isDeleting
                      ? null
                      : () =>
                            onDeletionConfirmationChanged(!isDeletionConfirmed),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          key: const ValueKey('confirm_deletion_checkbox'),
                          value: isDeletionConfirmed,
                          onChanged: isDeleting
                              ? null
                              : (value) => onDeletionConfirmationChanged(
                                  value ?? false,
                                ),
                          activeColor: AppColors.errorRed,
                          side: const BorderSide(color: AppColors.borderGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(width: AppResponsive.value(context, 8)),
                      Expanded(
                        child: Text(
                          'I understand this is permanent and irreversible',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 11.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 12)),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: AppResponsive.value(context, 42),
                        child: OutlinedButton(
                          key: const ValueKey('cancel_deletion_button'),
                          onPressed: isDeleting ? null : onCancelDeletion,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.cream,
                            foregroundColor: AppColors.darkGreen,
                            side: const BorderSide(
                              color: AppColors.borderGreen,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: AppResponsive.font(context, 13),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppResponsive.value(context, 10)),
                    Expanded(
                      child: SizedBox(
                        height: AppResponsive.value(context, 42),
                        child: FilledButton(
                          key: const ValueKey('delete_account_button'),
                          onPressed: isDeletionConfirmed && !isDeleting
                              ? onConfirmDeleteAccount
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.peach,
                            disabledBackgroundColor: AppColors.peach.withValues(
                              alpha: 0.45,
                            ),
                            foregroundColor: AppColors.errorRed,
                            disabledForegroundColor: AppColors.errorRed
                                .withValues(alpha: 0.45),
                            side: BorderSide(
                              color: AppColors.errorRed.withValues(
                                alpha: isDeletionConfirmed ? 0.35 : 0.15,
                              ),
                            ),
                            shape: const StadiumBorder(),
                          ),
                          child: isDeleting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.errorRed,
                                  ),
                                )
                              : Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: AppResponsive.font(context, 13),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
