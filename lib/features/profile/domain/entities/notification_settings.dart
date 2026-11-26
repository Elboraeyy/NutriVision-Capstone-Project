/// Device notification permission states exposed to the domain and UI.
enum NotificationPermissionStatus {
  notChecked,
  granted,
  denied,
  permanentlyDenied,
}

/// Meal logging reminder schedule options.
enum MealReminderSchedule {
  off('Off'),
  threeMeals('3 meals daily'),
  twoMeals('2 meals daily'),
  lunchOnly('Lunch only');

  const MealReminderSchedule(this.label);
  final String label;
}

/// Water intake reminder frequency options.
enum WaterReminderSchedule {
  off('Off'),
  everyTwoHours('Every 2 hrs'),
  everyThreeHours('Every 3 hrs'),
  morningEvening('2x daily');

  const WaterReminderSchedule(this.label);
  final String label;
}

/// Sound preference options for reminders.
enum ReminderSoundPreference {
  systemDefault('Default'),
  vibrateOnly('Vibrate only'),
  silent('Silent');

  const ReminderSoundPreference(this.label);
  final String label;
}

/// Pure Dart representation of a wall-clock time without Flutter UI imports.
class TimeOfDayValue {
  const TimeOfDayValue({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  final int hour;
  final int minute;

  int get totalMinutes => hour * 60 + minute;

  String format12Hour() {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeOfDayValue &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode => Object.hash(hour, minute);
}

/// Quiet-hours time window where reminders stay muted or gentler.
class QuietHoursRange {
  const QuietHoursRange({required this.start, required this.end});

  final TimeOfDayValue start;
  final TimeOfDayValue end;

  /// Duration in minutes, supporting overnight ranges (e.g. 10:00 PM - 7:00 AM).
  int get durationMinutes {
    final diff = end.totalMinutes - start.totalMinutes;
    return diff >= 0 ? diff : (24 * 60) + diff;
  }

  String? get validationError {
    if (start == end) {
      return 'Start and end times cannot be the same.';
    }
    if (durationMinutes < 30) {
      return 'Quiet hours must span at least 30 minutes.';
    }
    return null;
  }

  bool get isValid => validationError == null;

  String formatRange() => '${start.format12Hour()} – ${end.format12Hour()}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuietHoursRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

/// User notification preferences persisted as draft/saved settings.
class NotificationSettings {
  const NotificationSettings({
    this.mealSchedule,
    this.waterSchedule,
    this.soundPreference,
    this.quietHours,
  });

  final MealReminderSchedule? mealSchedule;
  final WaterReminderSchedule? waterSchedule;
  final ReminderSoundPreference? soundPreference;
  final QuietHoursRange? quietHours;

  bool get hasAnySelection =>
      mealSchedule != null ||
      waterSchedule != null ||
      soundPreference != null ||
      quietHours != null;

  NotificationSettings copyWith({
    MealReminderSchedule? mealSchedule,
    bool clearMealSchedule = false,
    WaterReminderSchedule? waterSchedule,
    bool clearWaterSchedule = false,
    ReminderSoundPreference? soundPreference,
    bool clearSoundPreference = false,
    QuietHoursRange? quietHours,
    bool clearQuietHours = false,
  }) {
    return NotificationSettings(
      mealSchedule: clearMealSchedule
          ? null
          : (mealSchedule ?? this.mealSchedule),
      waterSchedule: clearWaterSchedule
          ? null
          : (waterSchedule ?? this.waterSchedule),
      soundPreference: clearSoundPreference
          ? null
          : (soundPreference ?? this.soundPreference),
      quietHours: clearQuietHours ? null : (quietHours ?? this.quietHours),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSettings &&
        other.mealSchedule == mealSchedule &&
        other.waterSchedule == waterSchedule &&
        other.soundPreference == soundPreference &&
        other.quietHours == quietHours;
  }

  @override
  int get hashCode =>
      Object.hash(mealSchedule, waterSchedule, soundPreference, quietHours);
}
