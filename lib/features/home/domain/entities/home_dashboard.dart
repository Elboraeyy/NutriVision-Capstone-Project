class HomeDashboard {
  const HomeDashboard({
    required this.dayLabel,
    required this.nutrition,
    required this.water,
    required this.recentMeal,
    required this.suggestion,
  });

  final String dayLabel;
  final NutritionSummary nutrition;
  final WaterSummary water;
  final RecentMeal recentMeal;
  final MealSuggestion suggestion;
}

class NutritionSummary {
  const NutritionSummary({
    required this.consumedCalories,
    required this.remainingCalories,
    required this.goalCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int consumedCalories;
  final int remainingCalories;
  final int goalCalories;
  final MacroSummary protein;
  final MacroSummary carbs;
  final MacroSummary fat;
}

class MacroSummary {
  const MacroSummary({
    required this.label,
    required this.consumed,
    required this.goal,
  });

  final String label;
  final int consumed;
  final int goal;
}

class WaterSummary {
  const WaterSummary({required this.consumedMl, required this.goalMl});

  final int consumedMl;
  final int goalMl;
}

class RecentMeal {
  const RecentMeal({
    required this.title,
    required this.time,
    required this.calories,
  });

  final String title;
  final String time;
  final int calories;
}

class MealSuggestion {
  const MealSuggestion({
    required this.title,
    required this.description,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.tag,
  });

  final String title;
  final String description;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String tag;
}
