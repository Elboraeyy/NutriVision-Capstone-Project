import 'dart:convert';

import '../../domain/entities/goals_dietary_preferences.dart';

/// JSON serialization model for [GoalsDietaryPreferences].
class GoalsDietaryPreferencesModel {
  const GoalsDietaryPreferencesModel({required this.preferences});

  final GoalsDietaryPreferences preferences;

  Map<String, dynamic> toJson() {
    return {
      'goal': preferences.goal,
      'allergies': preferences.allergies,
      'dailyTargets': {
        'calories': preferences.dailyTargets.calories,
        'protein': preferences.dailyTargets.protein,
        'carbohydrates': preferences.dailyTargets.carbohydrates,
        'fat': preferences.dailyTargets.fat,
        'water': preferences.dailyTargets.water,
      },
      'dietaryPattern': preferences.dietaryPattern,
      'excludedIngredients': preferences.excludedIngredients,
      'likedFoods': preferences.likedFoods,
    };
  }

  String encode() => jsonEncode(toJson());

  static GoalsDietaryPreferences? tryDecode(String? rawJson) {
    if (rawJson == null || rawJson.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) return null;

      final targetsRaw = decoded['dailyTargets'];
      final targetsMap = targetsRaw is Map<String, dynamic>
          ? targetsRaw
          : const <String, dynamic>{};

      final dailyTargets = DailyTargets(
        calories: _parseNonNegativeInt(targetsMap['calories']),
        protein: _parseNonNegativeInt(targetsMap['protein']),
        carbohydrates: _parseNonNegativeInt(targetsMap['carbohydrates']),
        fat: _parseNonNegativeInt(targetsMap['fat']),
        water: _parseNonNegativeInt(targetsMap['water']),
      );

      return GoalsDietaryPreferences(
        goal: _parseString(
          decoded['goal'],
          fallback: GoalsDietaryPreferences.defaultGoal,
        ),
        allergies: _parseStringList(decoded['allergies']),
        dailyTargets: dailyTargets,
        dietaryPattern: _parseString(
          decoded['dietaryPattern'],
          fallback: GoalsDietaryPreferences.defaultDietaryPattern,
        ),
        excludedIngredients: _parseStringList(decoded['excludedIngredients']),
        likedFoods: _parseStringList(decoded['likedFoods']),
      );
    } catch (_) {
      return null;
    }
  }

  static int _parseNonNegativeInt(dynamic value) {
    if (value is int) return value < 0 ? 0 : value;
    if (value is num) {
      final intVal = value.toInt();
      return intVal < 0 ? 0 : intVal;
    }
    return 0;
  }

  static String _parseString(dynamic value, {required String fallback}) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return fallback;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
