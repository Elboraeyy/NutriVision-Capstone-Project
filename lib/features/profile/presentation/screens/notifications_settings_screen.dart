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
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../domain/entities/notification_settings.dart';
import '../bloc/notifications_settings_bloc.dart';
import '../widgets/notifications_settings_widgets.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<NotificationsSettingsBloc>().add(
      const NotificationsSettingsStarted(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<NotificationsSettingsBloc>().add(
        const NotificationPermissionChecked(),
      );
    }
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('profile');
    }
  }

  Future<void> _configureQuietHours(
    BuildContext context,
    QuietHoursRange? current,
  ) async {
    final result = await showQuietHoursPickerDialog(
      context,
      initialRange: current,
    );
    if (result == null || !context.mounted) return;
    context.read<NotificationsSettingsBloc>().add(
      QuietHoursChanged(result.cleared ? null : result.range),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    if (index == 0) {
      context.read<HomeBloc>().add(const HomeTabSelected(0));
      context.goNamed('home');
      return;
    }
    if (index == 4) {
      _navigateBack(context);
      return;
    }
    AppToast.show(
      context,
      message: '${appNavigationItems[index].label} will be connected soon.',
      type: AppToastType.info,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(
      context,
      NotificationsSettingsHeader.baseHeight,
    );
    final overlap = AppResponsive.value(
      context,
      NotificationsSettingsHeader.overlapDepth,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<NotificationsSettingsBloc, NotificationsSettingsState>(
        listenWhen: (previous, current) =>
            (previous.status != current.status &&
                (current.status == NotificationsSettingsStatus.saved ||
                    current.status == NotificationsSettingsStatus.failure)) ||
            (previous.message != current.message &&
                current.message != null &&
                current.status == NotificationsSettingsStatus.ready),
        listener: (context, state) {
          final message = state.message;
          if (message == null || message.isEmpty) return;
          final type = switch (state.status) {
            NotificationsSettingsStatus.saved => AppToastType.success,
            NotificationsSettingsStatus.failure => AppToastType.error,
            _ =>
              state.permissionStatus == NotificationPermissionStatus.granted
                  ? AppToastType.success
                  : AppToastType.warning,
          };
          AppToast.show(context, message: message, type: type);
        },
        builder: (context, state) {
          if (state.status == NotificationsSettingsStatus.loading ||
              state.status == NotificationsSettingsStatus.initial) {
            return AppOverlayScaffold(
              header: NotificationsSettingsHeader(
                onBack: () => _navigateBack(context),
              ),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              ),
            );
          }

          final draft = state.draftSettings;
          final saved = state.savedSettings;

          final mealActions = <SettingsDropdownAction>[
            for (final option in MealReminderSchedule.values)
              SettingsDropdownAction(
                label: option.label,
                isSelected: draft.mealSchedule == option,
                onSelected: () => context.read<NotificationsSettingsBloc>().add(
                  MealScheduleChanged(option),
                ),
              ),
          ];

          final waterActions = <SettingsDropdownAction>[
            for (final option in WaterReminderSchedule.values)
              SettingsDropdownAction(
                label: option.label,
                isSelected: draft.waterSchedule == option,
                onSelected: () => context.read<NotificationsSettingsBloc>().add(
                  WaterScheduleChanged(option),
                ),
              ),
          ];

          final draftStatusLabel = !state.hasSavedSettings
              ? 'Draft only · No changes saved yet'
              : state.hasUnsavedChanges
              ? 'Unsaved changes · Tap Save changes to keep'
              : 'Saved · Preferences stored on this device';

          return AppOverlayScaffold(
            header: NotificationsSettingsHeader(
              onBack: () => _navigateBack(context),
            ),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: headerHeight - overlap),
                          child: Stack(
                            children: [
                              Container(
                                height: overlap * 2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      AppResponsive.value(context, 38),
                                    ),
                                    bottomRight: Radius.circular(
                                      AppResponsive.value(context, 38),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppResponsive.value(context, 20),
                                  overlap,
                                  AppResponsive.value(context, 20),
                                  0,
                                ),
                                child: DevicePermissionCard(
                                  permissionStatus: state.permissionStatus,
                                  isChecking: state.isCheckingPermission,
                                  onRequestPermission: () => context
                                      .read<NotificationsSettingsBloc>()
                                      .add(
                                        const NotificationPermissionRequested(),
                                      ),
                                  onCheckPermission: () => context
                                      .read<NotificationsSettingsBloc>()
                                      .add(
                                        const NotificationPermissionChecked(),
                                      ),
                                  onOpenAppSettings: () => context
                                      .read<NotificationsSettingsBloc>()
                                      .add(
                                        const NotificationAppSettingsOpened(),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppResponsive.value(context, 20),
                          AppResponsive.value(context, 16),
                          AppResponsive.value(context, 20),
                          AppResponsive.value(context, 96),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            ReminderScheduleCard(
                              icon: Icons.restaurant_rounded,
                              title: 'Meal logging reminders',
                              savedSubtitle: saved?.mealSchedule == null
                                  ? 'No saved schedule'
                                  : 'Saved: ${saved!.mealSchedule!.label}',
                              rowLabel: 'Meal reminders',
                              selectedLabel:
                                  draft.mealSchedule?.label ?? 'Choose',
                              dropdownKey: const ValueKey(
                                'meal_reminders_dropdown',
                              ),
                              actions: mealActions,
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            ReminderScheduleCard(
                              icon: Icons.water_drop_outlined,
                              title: 'Water reminders',
                              savedSubtitle: saved?.waterSchedule == null
                                  ? 'No saved schedule'
                                  : 'Saved: ${saved!.waterSchedule!.label}',
                              rowLabel: 'Water reminders',
                              selectedLabel:
                                  draft.waterSchedule?.label ?? 'Choose',
                              dropdownKey: const ValueKey(
                                'water_reminders_dropdown',
                              ),
                              actions: waterActions,
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            SoundAndQuietHoursCard(
                              selectedSound: draft.soundPreference,
                              onSoundChanged: (sound) => context
                                  .read<NotificationsSettingsBloc>()
                                  .add(ReminderSoundChanged(sound)),
                              quietHours: draft.quietHours,
                              onConfigureQuietHours: () => _configureQuietHours(
                                context,
                                draft.quietHours,
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            Text(
                              'Schedules and preferences are editable drafts, not active reminders.',
                              style: TextStyle(
                                color: AppColors.mutedGreen,
                                fontSize: AppResponsive.font(context, 11),
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 14)),
                            SizedBox(
                              height: AppResponsive.value(context, 54),
                              width: double.infinity,
                              child: FilledButton(
                                onPressed:
                                    state.status ==
                                        NotificationsSettingsStatus.saving
                                    ? null
                                    : () => context
                                          .read<NotificationsSettingsBloc>()
                                          .add(
                                            const NotificationsSettingsSaved(),
                                          ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                                child:
                                    state.status ==
                                        NotificationsSettingsStatus.saving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Save changes',
                                        style: TextStyle(
                                          fontSize: AppResponsive.font(
                                            context,
                                            15,
                                          ),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 10)),
                            Text(
                              draftStatusLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.mutedGreen,
                                fontSize: AppResponsive.font(context, 11),
                              ),
                            ),
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
                    onSelected: (index) => _handleBottomNavTap(context, index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
