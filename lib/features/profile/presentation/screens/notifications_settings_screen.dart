import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/notification_preferences.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_widgets.dart';

/// Notifications Settings screen matching Figma node 206:5840.
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  static const double _headerHeight = 198;

  late NotificationPreferences _draft;
  bool _hasUnsavedEdits = false;

  @override
  void initState() {
    super.initState();
    _draft = context.read<ProfileBloc>().state.profile.notifications;
  }

  void _updateDraft(NotificationPreferences next) {
    setState(() {
      _draft = next;
      _hasUnsavedEdits = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(context, _headerHeight);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.actionNonce != curr.actionNonce,
        listener: (context, state) {
          if (state.actionStatus == ProfileActionStatus.notificationsSaved) {
            setState(() {
              _draft = state.profile.notifications;
              _hasUnsavedEdits = false;
            });
            AppToast.show(
              context,
              message: state.message ?? 'Notification settings saved.',
              type: AppToastType.success,
            );
          } else if (state.actionStatus == ProfileActionStatus.failure &&
              state.message != null) {
            AppToast.show(
              context,
              message: state.message!,
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          return AppOverlayScaffold(
            header: ProfileHeader(
              backLabel: 'Profile & Settings',
              title: 'Notifications\nsettings.',
              subtitle: 'A routine that works for you.',
              height: _headerHeight,
              onBack: () => context.pop(),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 20),
                headerHeight + AppResponsive.value(context, 16),
                AppResponsive.value(context, 20),
                AppResponsive.value(context, 114),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device permission
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Device permission',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        Text(
                          'Permission hasn’t been checked. You may need to allow notifications in your device settings.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        _NotificationPreferenceRow(
                          label: 'Push notifications',
                          value: _draft.pushPermission ?? 'Choose',
                          onTap: () => _pickOption(
                            title: 'Push notifications',
                            options: const ['Enabled', 'Muted', 'Ask later'],
                            current: _draft.pushPermission,
                            onSelected: (val) => _updateDraft(
                              _draft.copyWith(pushPermission: val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Meal logging reminders
                  ProfileCard(
                    backgroundColor: AppColors.softGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileSettingsOptionRow(
                          icon: Icons.restaurant_rounded,
                          iconBackgroundColor: kProfileCardSurface,
                          title: 'Meal logging reminders',
                          subtitle:
                              _draft.mealReminderSchedule ??
                              'No saved schedule',
                          showChevron: false,
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        _NotificationPreferenceRow(
                          label: 'Meal reminders',
                          value: _draft.mealReminderSchedule ?? 'Choose',
                          onTap: () => _pickOption(
                            title: 'Meal reminders',
                            options: const [
                              'Off',
                              'Breakfast & Dinner',
                              'All 3 meals',
                            ],
                            current: _draft.mealReminderSchedule,
                            onSelected: (val) => _updateDraft(
                              _draft.copyWith(mealReminderSchedule: val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Water reminders
                  ProfileCard(
                    backgroundColor: AppColors.softGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileSettingsOptionRow(
                          icon: Icons.water_drop_outlined,
                          iconBackgroundColor: kProfileCardSurface,
                          title: 'Water reminders',
                          subtitle:
                              _draft.waterReminderSchedule ??
                              'No saved schedule',
                          showChevron: false,
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        _NotificationPreferenceRow(
                          label: 'Water reminders',
                          value: _draft.waterReminderSchedule ?? 'Choose',
                          onTap: () => _pickOption(
                            title: 'Water reminders',
                            options: const [
                              'Off',
                              'Every 2 hours',
                              'Every 3 hours',
                            ],
                            current: _draft.waterReminderSchedule,
                            onSelected: (val) => _updateDraft(
                              _draft.copyWith(waterReminderSchedule: val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Sound & quiet hours
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sound & quiet hours',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        _NotificationPreferenceRow(
                          label: 'Reminder sound',
                          value: _draft.reminderSound ?? 'Choose',
                          onTap: () => _pickOption(
                            title: 'Reminder sound',
                            options: const [
                              'Default chime',
                              'Soft tone',
                              'Vibrate only',
                              'Silent',
                            ],
                            current: _draft.reminderSound,
                            onSelected: (val) => _updateDraft(
                              _draft.copyWith(reminderSound: val),
                            ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        const ProfileDivider(),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        _NotificationPreferenceRow(
                          label: 'Quiet hours',
                          value: _draft.quietHours ?? 'Not set',
                          onTap: () => _pickOption(
                            title: 'Quiet hours',
                            options: const [
                              'Off',
                              '10:00 PM – 7:00 AM',
                              '11:00 PM – 8:00 AM',
                            ],
                            current: _draft.quietHours,
                            onSelected: (val) =>
                                _updateDraft(_draft.copyWith(quietHours: val)),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        Text(
                          'Choose a sound preference and a time range for quieter reminders.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  Text(
                    'Schedules and preferences are editable drafts, not active reminders.',
                    style: TextStyle(
                      color: AppColors.mutedGreen,
                      fontSize: AppResponsive.font(context, 12),
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  SizedBox(
                    width: double.infinity,
                    height: AppResponsive.value(context, 48),
                    child: FilledButton(
                      onPressed: state.isSaving
                          ? null
                          : () => context.read<ProfileBloc>().add(
                              ProfileNotificationsSaved(_draft),
                            ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        state.isSaving ? 'Saving...' : 'Save changes',
                        style: TextStyle(
                          fontSize: AppResponsive.font(context, 13),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 10)),
                  Center(
                    child: Text(
                      _hasUnsavedEdits
                          ? 'Draft only · No changes saved yet'
                          : (_draft.hasAnySelection
                                ? 'Saved notification preferences'
                                : 'Draft only · No changes saved yet'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            foregrounds: const [ProfileBottomNav()],
          );
        },
      ),
    );
  }

  Future<void> _pickOption({
    required String title,
    required List<String> options,
    required String? current,
    required ValueChanged<String> onSelected,
  }) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.value(sheetContext, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(sheetContext, 17),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppResponsive.value(sheetContext, 12)),
              ...options.map((option) {
                final selected = option == current;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(Icons.check_circle, color: AppColors.green)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(option),
                );
              }),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) {
      onSelected(chosen);
    }
  }
}

class _NotificationPreferenceRow extends StatelessWidget {
  const _NotificationPreferenceRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
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
          ProfileSelectorPill(label: value, onTap: onTap),
        ],
      ),
    );
  }
}
