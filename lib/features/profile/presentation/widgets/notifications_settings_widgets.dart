import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../domain/entities/notification_settings.dart';

/// Green rounded header with a back link to Profile & Settings.
class NotificationsSettingsHeader extends StatelessWidget {
  const NotificationsSettingsHeader({super.key, required this.onBack});

  static const double baseHeight = 152;
  static const double overlapDepth = 38;

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
                  'Notifications\nsettings.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.font(context, 27),
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 6)),
                Text(
                  'A routine that works for you.',
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

/// Menu choice rendered inside [SettingsActionDropdown].
class SettingsDropdownAction {
  const SettingsDropdownAction({
    required this.label,
    required this.onSelected,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onSelected;
  final bool isSelected;
}

/// Rounded bordered pill button displaying a dropdown menu of actions.
class SettingsActionDropdown extends StatelessWidget {
  const SettingsActionDropdown({
    super.key,
    required this.label,
    required this.actions,
    this.semanticsLabel,
  });

  final String label;
  final List<SettingsDropdownAction> actions;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      child: PopupMenuButton<int>(
        tooltip: semanticsLabel ?? label,
        color: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGreen),
        ),
        onSelected: (index) => actions[index].onSelected(),
        itemBuilder: (_) => [
          for (var i = 0; i < actions.length; i++)
            PopupMenuItem<int>(
              value: i,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      actions[i].label,
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 13),
                        fontWeight: actions[i].isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (actions[i].isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_rounded,
                      color: AppColors.green,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
        ],
        child: _DropdownPillSurface(label: label),
      ),
    );
  }
}

/// Rounded bordered pill button used for direct custom pickers (e.g. quiet hours).
class SettingsPickerPill extends StatelessWidget {
  const SettingsPickerPill({
    super.key,
    required this.label,
    required this.onTap,
    this.semanticsLabel,
  });

  final String label;
  final VoidCallback onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: _DropdownPillSurface(label: label),
        ),
      ),
    );
  }
}

class _DropdownPillSurface extends StatelessWidget {
  const _DropdownPillSurface({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: AppResponsive.value(context, 94),
        maxWidth: AppResponsive.value(context, 170),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 12),
        vertical: AppResponsive.value(context, 7),
      ),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.borderGreen),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 12),
                fontWeight: FontWeight.w600,
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
    );
  }
}

Color _lightSettingsCardColor() =>
    Color.alphaBlend(AppColors.softGreen.withValues(alpha: .55), Colors.white);

/// Device notification permission card displaying real status and actions.
class DevicePermissionCard extends StatelessWidget {
  const DevicePermissionCard({
    super.key,
    required this.permissionStatus,
    required this.isChecking,
    required this.onRequestPermission,
    required this.onCheckPermission,
    required this.onOpenAppSettings,
  });

  final NotificationPermissionStatus permissionStatus;
  final bool isChecking;
  final VoidCallback onRequestPermission;
  final VoidCallback onCheckPermission;
  final VoidCallback onOpenAppSettings;

  @override
  Widget build(BuildContext context) {
    final description = switch (permissionStatus) {
      NotificationPermissionStatus.notChecked =>
        "Permission hasn't been checked. You may need to allow notifications in your device settings.",
      NotificationPermissionStatus.granted =>
        'Notifications are allowed on this device. Saved preferences stay as drafts until activated.',
      NotificationPermissionStatus.denied =>
        'Notifications are currently off. Allow permission or update it in your device settings.',
      NotificationPermissionStatus.permanentlyDenied =>
        'Notifications are blocked in device settings. Open app settings to allow them.',
    };

    final pillLabel = switch (permissionStatus) {
      NotificationPermissionStatus.notChecked => 'Choose',
      NotificationPermissionStatus.granted => 'Allowed',
      NotificationPermissionStatus.denied => 'Denied',
      NotificationPermissionStatus.permanentlyDenied => 'Blocked',
    };

    final actions = <SettingsDropdownAction>[
      if (permissionStatus == NotificationPermissionStatus.notChecked ||
          permissionStatus == NotificationPermissionStatus.denied)
        SettingsDropdownAction(
          label: 'Allow notifications',
          onSelected: onRequestPermission,
        ),
      SettingsDropdownAction(
        label: 'Check status',
        onSelected: onCheckPermission,
      ),
      SettingsDropdownAction(
        label: 'Open app settings',
        onSelected: onOpenAppSettings,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: _lightSettingsCardColor(),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Device permission',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 15),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (isChecking)
                SizedBox(
                  width: AppResponsive.value(context, 14),
                  height: AppResponsive.value(context, 14),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.green,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Text(
            description,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11.5),
              height: 1.35,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Push notifications',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              SettingsActionDropdown(
                key: const ValueKey('push_notifications_dropdown'),
                label: pillLabel,
                actions: actions,
                semanticsLabel: 'Push notifications permission',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Reusable reminder schedule card for Meal logging & Water reminders.
class ReminderScheduleCard extends StatelessWidget {
  const ReminderScheduleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.savedSubtitle,
    required this.rowLabel,
    required this.selectedLabel,
    required this.actions,
    this.dropdownKey,
  });

  final IconData icon;
  final String title;
  final String savedSubtitle;
  final String rowLabel;
  final String selectedLabel;
  final List<SettingsDropdownAction> actions;
  final Key? dropdownKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.darkGreen,
                size: AppResponsive.value(context, 22),
              ),
              SizedBox(width: AppResponsive.value(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 15),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 2)),
                    Text(
                      savedSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 18)),
          Row(
            children: [
              Expanded(
                child: Text(
                  rowLabel,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              SettingsActionDropdown(
                key: dropdownKey,
                label: selectedLabel,
                actions: actions,
                semanticsLabel: rowLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sound preference and quiet-hours card.
class SoundAndQuietHoursCard extends StatelessWidget {
  const SoundAndQuietHoursCard({
    super.key,
    required this.selectedSound,
    required this.onSoundChanged,
    required this.quietHours,
    required this.onConfigureQuietHours,
  });

  final ReminderSoundPreference? selectedSound;
  final ValueChanged<ReminderSoundPreference?> onSoundChanged;
  final QuietHoursRange? quietHours;
  final VoidCallback onConfigureQuietHours;

  @override
  Widget build(BuildContext context) {
    final soundActions = <SettingsDropdownAction>[
      for (final option in ReminderSoundPreference.values)
        SettingsDropdownAction(
          label: option.label,
          isSelected: selectedSound == option,
          onSelected: () => onSoundChanged(option),
        ),
      if (selectedSound != null)
        SettingsDropdownAction(
          label: 'Clear selection',
          onSelected: () => onSoundChanged(null),
        ),
    ];

    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: _lightSettingsCardColor(),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sound & quiet hours',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 15),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reminder sound',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              SettingsActionDropdown(
                key: const ValueKey('reminder_sound_dropdown'),
                label: selectedSound?.label ?? 'Choose',
                actions: soundActions,
                semanticsLabel: 'Reminder sound',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.value(context, 14),
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.borderGreen.withValues(alpha: .55),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quiet hours',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              SettingsPickerPill(
                key: const ValueKey('quiet_hours_picker'),
                label: quietHours?.formatRange() ?? 'Not set',
                onTap: onConfigureQuietHours,
                semanticsLabel: 'Quiet hours',
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            'Choose a sound preference and a time range for quieter reminders.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog action returned when configuring quiet hours.
class QuietHoursDialogResult {
  const QuietHoursDialogResult({required this.cleared, this.range});

  final bool cleared;
  final QuietHoursRange? range;
}

/// Interactive quiet-hours range dialog using Flutter's [showTimePicker].
Future<QuietHoursDialogResult?> showQuietHoursPickerDialog(
  BuildContext context, {
  QuietHoursRange? initialRange,
}) {
  return showDialog<QuietHoursDialogResult>(
    context: context,
    builder: (_) => _QuietHoursPickerDialog(initialRange: initialRange),
  );
}

class _QuietHoursPickerDialog extends StatefulWidget {
  const _QuietHoursPickerDialog({this.initialRange});

  final QuietHoursRange? initialRange;

  @override
  State<_QuietHoursPickerDialog> createState() =>
      _QuietHoursPickerDialogState();
}

class _QuietHoursPickerDialogState extends State<_QuietHoursPickerDialog> {
  late TimeOfDayValue _start;
  late TimeOfDayValue _end;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _start =
        widget.initialRange?.start ?? const TimeOfDayValue(hour: 22, minute: 0);
    _end = widget.initialRange?.end ?? const TimeOfDayValue(hour: 7, minute: 0);
    _validationError = QuietHoursRange(
      start: _start,
      end: _end,
    ).validationError;
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _start.hour, minute: _start.minute),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _start = TimeOfDayValue(hour: picked.hour, minute: picked.minute);
      _validationError = QuietHoursRange(
        start: _start,
        end: _end,
      ).validationError;
    });
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _end.hour, minute: _end.minute),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _end = TimeOfDayValue(hour: picked.hour, minute: picked.minute);
      _validationError = QuietHoursRange(
        start: _start,
        end: _end,
      ).validationError;
    });
  }

  @override
  Widget build(BuildContext context) {
    final candidate = QuietHoursRange(start: _start, end: _end);

    return AlertDialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      title: Text(
        'Quiet hours',
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppResponsive.font(context, 18),
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select start and end times. Overnight ranges are supported.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          _TimeSelectionRow(
            label: 'Start time',
            value: _start.format12Hour(),
            onTap: _pickStartTime,
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          _TimeSelectionRow(
            label: 'End time',
            value: _end.format12Hour(),
            onTap: _pickEndTime,
          ),
          if (_validationError != null) ...[
            SizedBox(height: AppResponsive.value(context, 12)),
            Text(
              _validationError!,
              style: TextStyle(
                color: AppColors.errorRed,
                fontSize: AppResponsive.font(context, 12),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (widget.initialRange != null)
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(const QuietHoursDialogResult(cleared: true)),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text(
              'Clear',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.darkGreen),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        FilledButton(
          onPressed: candidate.isValid
              ? () => Navigator.of(
                  context,
                ).pop(QuietHoursDialogResult(cleared: false, range: candidate))
              : null,
          child: const Text(
            'Apply',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _TimeSelectionRow extends StatelessWidget {
  const _TimeSelectionRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SettingsPickerPill(label: value, onTap: onTap),
      ],
    );
  }
}
