import 'dart:convert';

import '../../domain/entities/notification_settings.dart';

/// Serialization model mapping [NotificationSettings] to and from JSON.
class NotificationSettingsModel {
  const NotificationSettingsModel({
    this.mealScheduleName,
    this.waterScheduleName,
    this.soundPreferenceName,
    this.quietStartHour,
    this.quietStartMinute,
    this.quietEndHour,
    this.quietEndMinute,
  });

  final String? mealScheduleName;
  final String? waterScheduleName;
  final String? soundPreferenceName;
  final int? quietStartHour;
  final int? quietStartMinute;
  final int? quietEndHour;
  final int? quietEndMinute;

  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) {
    return NotificationSettingsModel(
      mealScheduleName: entity.mealSchedule?.name,
      waterScheduleName: entity.waterSchedule?.name,
      soundPreferenceName: entity.soundPreference?.name,
      quietStartHour: entity.quietHours?.start.hour,
      quietStartMinute: entity.quietHours?.start.minute,
      quietEndHour: entity.quietHours?.end.hour,
      quietEndMinute: entity.quietHours?.end.minute,
    );
  }

  static NotificationSettingsModel? tryDecode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return NotificationSettingsModel(
        mealScheduleName: decoded['mealSchedule'] as String?,
        waterScheduleName: decoded['waterSchedule'] as String?,
        soundPreferenceName: decoded['soundPreference'] as String?,
        quietStartHour: decoded['quietStartHour'] as int?,
        quietStartMinute: decoded['quietStartMinute'] as int?,
        quietEndHour: decoded['quietEndHour'] as int?,
        quietEndMinute: decoded['quietEndMinute'] as int?,
      );
    } catch (_) {
      return null;
    }
  }

  String encode() {
    return jsonEncode({
      'mealSchedule': mealScheduleName,
      'waterSchedule': waterScheduleName,
      'soundPreference': soundPreferenceName,
      'quietStartHour': quietStartHour,
      'quietStartMinute': quietStartMinute,
      'quietEndHour': quietEndHour,
      'quietEndMinute': quietEndMinute,
    });
  }

  NotificationSettings toEntity() {
    return NotificationSettings(
      mealSchedule: _enumByName(MealReminderSchedule.values, mealScheduleName),
      waterSchedule: _enumByName(
        WaterReminderSchedule.values,
        waterScheduleName,
      ),
      soundPreference: _enumByName(
        ReminderSoundPreference.values,
        soundPreferenceName,
      ),
      quietHours: _buildQuietHours(),
    );
  }

  QuietHoursRange? _buildQuietHours() {
    final startH = quietStartHour;
    final startM = quietStartMinute;
    final endH = quietEndHour;
    final endM = quietEndMinute;
    if (startH == null || startM == null || endH == null || endM == null) {
      return null;
    }
    if (startH < 0 ||
        startH >= 24 ||
        endH < 0 ||
        endH >= 24 ||
        startM < 0 ||
        startM >= 60 ||
        endM < 0 ||
        endM >= 60) {
      return null;
    }
    return QuietHoursRange(
      start: TimeOfDayValue(hour: startH, minute: startM),
      end: TimeOfDayValue(hour: endH, minute: endM),
    );
  }

  static T? _enumByName<T extends Enum>(List<T> values, String? name) {
    if (name == null) return null;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
