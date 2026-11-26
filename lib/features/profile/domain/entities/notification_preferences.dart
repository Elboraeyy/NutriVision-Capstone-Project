/// Editable draft/saved notification preferences for the user profile.
class NotificationPreferences {
  const NotificationPreferences({
    this.pushPermission,
    this.mealReminderSchedule,
    this.waterReminderSchedule,
    this.reminderSound,
    this.quietHours,
  });

  final String? pushPermission;
  final String? mealReminderSchedule;
  final String? waterReminderSchedule;
  final String? reminderSound;
  final String? quietHours;

  bool get hasAnySelection =>
      pushPermission != null ||
      mealReminderSchedule != null ||
      waterReminderSchedule != null ||
      reminderSound != null ||
      quietHours != null;

  NotificationPreferences copyWith({
    String? pushPermission,
    String? mealReminderSchedule,
    String? waterReminderSchedule,
    String? reminderSound,
    String? quietHours,
    bool clearPushPermission = false,
    bool clearMealReminderSchedule = false,
    bool clearWaterReminderSchedule = false,
    bool clearReminderSound = false,
    bool clearQuietHours = false,
  }) {
    return NotificationPreferences(
      pushPermission: clearPushPermission
          ? null
          : (pushPermission ?? this.pushPermission),
      mealReminderSchedule: clearMealReminderSchedule
          ? null
          : (mealReminderSchedule ?? this.mealReminderSchedule),
      waterReminderSchedule: clearWaterReminderSchedule
          ? null
          : (waterReminderSchedule ?? this.waterReminderSchedule),
      reminderSound: clearReminderSound
          ? null
          : (reminderSound ?? this.reminderSound),
      quietHours: clearQuietHours ? null : (quietHours ?? this.quietHours),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationPreferences &&
        other.pushPermission == pushPermission &&
        other.mealReminderSchedule == mealReminderSchedule &&
        other.waterReminderSchedule == waterReminderSchedule &&
        other.reminderSound == reminderSound &&
        other.quietHours == quietHours;
  }

  @override
  int get hashCode => Object.hash(
    pushPermission,
    mealReminderSchedule,
    waterReminderSchedule,
    reminderSound,
    quietHours,
  );
}
