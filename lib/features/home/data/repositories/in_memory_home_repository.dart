import '../../domain/entities/home_dashboard.dart';
import '../../domain/repositories/home_repository.dart';

/// Temporary data source used until the nutrition API/database is connected.
class InMemoryHomeRepository implements HomeRepository {
  @override
  Future<HomeDashboard> getDashboard() async {
    return const HomeDashboard(
      greetingName: 'Maya.',
      dayLabel: 'Wednesday, Oct 14',
      nutrition: NutritionSummary(
        consumedCalories: 1240,
        remainingCalories: 760,
        goalCalories: 2000,
        protein: MacroSummary(label: 'Protein', consumed: 85, goal: 120),
        carbs: MacroSummary(label: 'Carbs', consumed: 135, goal: 245),
        fat: MacroSummary(label: 'Fat', consumed: 40, goal: 60),
      ),
      water: WaterSummary(consumedMl: 1250, goalMl: 2000),
      recentMeal: RecentMeal(
        title: 'Chicken & quinoa bowl',
        time: 'Lunch · 12:30 PM',
        calories: 520,
      ),
      suggestion: MealSuggestion(
        title: 'Lemon salmon & couscous',
        description:
            'Helps close your 35 g protein gap while fitting your remaining calories.',
        calories: 420,
        proteinGrams: 35,
        carbsGrams: 48,
        fatGrams: 12,
        tag: 'For dinner',
      ),
    );
  }
}
