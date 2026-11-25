import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/water_intake_model.dart';

abstract interface class WaterLocalDataSource {
  Future<WaterIntakeModel> getTodayWater();
  Future<WaterIntakeModel> addWater(int amountMl);
  Future<WaterIntakeModel> setGoal(int goalMl);
  Future<WaterIntakeModel> resetTodayWater();
}

class SharedPreferencesWaterLocalDataSource implements WaterLocalDataSource {
  SharedPreferencesWaterLocalDataSource([SharedPreferences? preferences])
    : _preferences = preferences;

  SharedPreferences? _preferences;

  static const _keyConsumedMl = 'water_tracker_consumed_ml';
  static const _keyGoalMl = 'water_tracker_goal_ml';
  static const _keyDate = 'water_tracker_date';
  static const int defaultGoalMl = 2000;

  Future<SharedPreferences> _getPrefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  String _getTodayDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Future<WaterIntakeModel> getTodayWater() async {
    final prefs = await _getPrefs();
    final today = _getTodayDate();
    final savedDate = prefs.getString(_keyDate);
    final goalMl = prefs.getInt(_keyGoalMl) ?? defaultGoalMl;

    if (savedDate == null || savedDate != today) {
      await prefs.setString(_keyDate, today);
      await prefs.setInt(_keyConsumedMl, 0);
      return WaterIntakeModel(consumedMl: 0, goalMl: goalMl, date: today);
    }

    final consumedMl = prefs.getInt(_keyConsumedMl) ?? 0;
    return WaterIntakeModel(
      consumedMl: consumedMl,
      goalMl: goalMl,
      date: today,
    );
  }

  @override
  Future<WaterIntakeModel> addWater(int amountMl) async {
    final current = await getTodayWater();
    if (amountMl <= 0) {
      return current;
    }

    final prefs = await _getPrefs();
    final newConsumed = current.consumedMl + amountMl;
    await prefs.setInt(_keyConsumedMl, newConsumed);

    return current.copyWith(consumedMl: newConsumed);
  }

  @override
  Future<WaterIntakeModel> setGoal(int goalMl) async {
    if (goalMl <= 0) {
      return getTodayWater();
    }
    final prefs = await _getPrefs();
    await prefs.setInt(_keyGoalMl, goalMl);
    final current = await getTodayWater();
    return current.copyWith(goalMl: goalMl);
  }

  @override
  Future<WaterIntakeModel> resetTodayWater() async {
    final prefs = await _getPrefs();
    final today = _getTodayDate();
    await prefs.setInt(_keyConsumedMl, 0);
    await prefs.setString(_keyDate, today);
    final goalMl = prefs.getInt(_keyGoalMl) ?? defaultGoalMl;
    return WaterIntakeModel(consumedMl: 0, goalMl: goalMl, date: today);
  }
}
