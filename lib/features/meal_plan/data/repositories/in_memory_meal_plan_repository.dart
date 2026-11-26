import 'dart:async';

import '../../domain/entities/daily_meal_plan.dart';
import '../../domain/entities/plan_nutrition.dart';
import '../../domain/entities/planned_meal.dart';
import '../../domain/repositories/meal_plan_repository.dart';

/// In-memory implementation of [MealPlanRepository].
///
/// Keeps track of the active daily meal plan and generates drafts with realistic
/// macros, calories, and alternatives matching the NutriVision designs.
class InMemoryMealPlanRepository implements MealPlanRepository {
  InMemoryMealPlanRepository() {
    _initDefaultPlan();
  }

  late DailyMealPlan _activePlan;

  final List<PlannedMeal> _breakfastAlternatives = [
    const PlannedMeal(
      id: 'm1_alt1',
      type: 'Breakfast',
      time: '8:00 AM',
      title: 'Berry & yogurt oats',
      calories: 420,
      protein: '24g',
      carbs: '56g',
      fat: '11g',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
      allergens: 'No peanuts · High fiber',
      tileColorHex: 0xFFF1E6B9,
    ),
    const PlannedMeal(
      id: 'm1_alt2',
      type: 'Breakfast',
      time: '8:00 AM',
      title: 'Avocado & poached egg toast',
      calories: 390,
      protein: '20g',
      carbs: '42g',
      fat: '16g',
      imageUrl:
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400',
      allergens: 'Dairy-free option · Nut-free',
      tileColorHex: 0xFFE1E8D6,
    ),
    const PlannedMeal(
      id: 'm1_alt3',
      type: 'Breakfast',
      time: '8:30 AM',
      title: 'Spinach & feta protein omelet',
      calories: 410,
      protein: '28g',
      carbs: '12g',
      fat: '22g',
      imageUrl:
          'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=400',
      allergens: 'Gluten-free · Safe ingredients',
      tileColorHex: 0xFFF2D7C8,
    ),
  ];

  final List<PlannedMeal> _lunchAlternatives = [
    const PlannedMeal(
      id: 'm2_alt1',
      type: 'Lunch',
      time: '12:30 PM',
      title: 'Chicken & quinoa bowl',
      calories: 580,
      protein: '48g',
      carbs: '62g',
      fat: '16g',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      allergens: 'Gluten-free · Allergen-tested',
      tileColorHex: 0xFFE1E8D6,
    ),
    const PlannedMeal(
      id: 'm2_alt2',
      type: 'Lunch',
      time: '1:00 PM',
      title: 'Mediterranean tuna power bowl',
      calories: 540,
      protein: '44g',
      carbs: '55g',
      fat: '14g',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      allergens: 'Nut-free · Omega-3 rich',
      tileColorHex: 0xFFF1E6B9,
    ),
  ];

  final List<PlannedMeal> _dinnerAlternatives = [
    const PlannedMeal(
      id: 'm3_alt1',
      type: 'Dinner',
      time: '7:00 PM',
      title: 'Lemon salmon & couscous',
      calories: 565,
      protein: '38g',
      carbs: '68g',
      fat: '15g',
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
      allergens: 'Safe ingredients · Checked peanut-free',
      tileColorHex: 0xFFF2D7C8,
    ),
    const PlannedMeal(
      id: 'm3_alt2',
      type: 'Dinner',
      time: '7:30 PM',
      title: 'Grilled turkey breast with roasted sweet potato',
      calories: 520,
      protein: '45g',
      carbs: '58g',
      fat: '11g',
      imageUrl:
          'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=400',
      allergens: 'Dairy-free · Nut-free',
      tileColorHex: 0xFFE1E8D6,
    ),
  ];

  final List<PlannedMeal> _snackAlternatives = [
    const PlannedMeal(
      id: 'm4_alt1',
      type: 'Snack',
      time: '4:00 PM',
      title: 'Roasted chickpea crunch',
      calories: 230,
      protein: '8g',
      carbs: '27g',
      fat: '11g',
      imageUrl:
          'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=400',
      allergens: 'Nut-free crunch · High plant protein',
      tileColorHex: 0xFFF1E6B9,
    ),
    const PlannedMeal(
      id: 'm4_alt2',
      type: 'Snack',
      time: '4:30 PM',
      title: 'Greek yogurt & chia pudding',
      calories: 210,
      protein: '14g',
      carbs: '22g',
      fat: '7g',
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      allergens: 'Nut-free · Probiotic boost',
      tileColorHex: 0xFFE1E8D6,
    ),
  ];

  int _breakfastIdx = 0;
  int _lunchIdx = 0;
  int _dinnerIdx = 0;
  int _snackIdx = 0;

  void _initDefaultPlan() {
    final now = DateTime.now();
    _activePlan = DailyMealPlan(
      date: now,
      formattedDate: _formatDate(now),
      isToday: true,
      nutrition: const PlanNutrition(
        calories: 1795,
        targetCalories: 2000,
        proteinGrams: 118,
        targetProteinGrams: 120,
        carbsGrams: 213,
        targetCarbsGrams: 245,
        fatGrams: 53,
        targetFatGrams: 60,
      ),
      meals: [
        _breakfastAlternatives[0],
        _lunchAlternatives[0],
        _dinnerAlternatives[0],
        _snackAlternatives[0],
      ],
      statusNote: '4 planned meals · Not logged',
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  @override
  Future<DailyMealPlan> getMealPlanForDate(DateTime date) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final isToday =
        date.year == _activePlan.date.year &&
        date.month == _activePlan.date.month &&
        date.day == _activePlan.date.day;

    return _activePlan.copyWith(
      date: date,
      formattedDate: _formatDate(date),
      isToday: isToday,
    );
  }

  @override
  Future<DailyMealPlan> generateAiPlan({
    required String goal,
    required int durationDays,
    required List<String> availableFoods,
    required String mealPattern,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    _breakfastIdx = (_breakfastIdx + 1) % _breakfastAlternatives.length;
    _lunchIdx = (_lunchIdx + 1) % _lunchAlternatives.length;
    _dinnerIdx = (_dinnerIdx + 1) % _dinnerAlternatives.length;
    _snackIdx = (_snackIdx + 1) % _snackAlternatives.length;

    final meals = [
      _breakfastAlternatives[_breakfastIdx],
      _lunchAlternatives[_lunchIdx],
      _dinnerAlternatives[_dinnerIdx],
      _snackAlternatives[_snackIdx],
    ];

    var totalCal = 0;
    var totalP = 0;
    var totalC = 0;
    var totalF = 0;

    for (final m in meals) {
      totalCal += m.calories;
      totalP += int.tryParse(m.protein.replaceAll('g', '')) ?? 0;
      totalC += int.tryParse(m.carbs.replaceAll('g', '')) ?? 0;
      totalF += int.tryParse(m.fat.replaceAll('g', '')) ?? 0;
    }

    return DailyMealPlan(
      date: DateTime.now(),
      formattedDate: _formatDate(DateTime.now()),
      isToday: true,
      nutrition: PlanNutrition(
        calories: totalCal,
        targetCalories: 2000,
        proteinGrams: totalP,
        targetProteinGrams: 120,
        carbsGrams: totalC,
        targetCarbsGrams: 245,
        fatGrams: totalF,
        targetFatGrams: 60,
      ),
      meals: meals,
      statusNote: 'AI generated draft · 4 planned meals',
    );
  }

  @override
  Future<PlannedMeal> cycleAlternativeMeal(String mealId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mealId.startsWith('m1')) {
      _breakfastIdx = (_breakfastIdx + 1) % _breakfastAlternatives.length;
      return _breakfastAlternatives[_breakfastIdx];
    } else if (mealId.startsWith('m2')) {
      _lunchIdx = (_lunchIdx + 1) % _lunchAlternatives.length;
      return _lunchAlternatives[_lunchIdx];
    } else if (mealId.startsWith('m3')) {
      _dinnerIdx = (_dinnerIdx + 1) % _dinnerAlternatives.length;
      return _dinnerAlternatives[_dinnerIdx];
    } else {
      _snackIdx = (_snackIdx + 1) % _snackAlternatives.length;
      return _snackAlternatives[_snackIdx];
    }
  }

  @override
  Future<void> replaceMeal(String mealId, PlannedMeal newMeal) async {
    final updatedMeals = _activePlan.meals.map((m) {
      if (m.id == mealId || m.type == newMeal.type) {
        return newMeal;
      }
      return m;
    }).toList();

    _activePlan = _activePlan.copyWith(meals: updatedMeals);
  }

  @override
  Future<void> approvePlan(DailyMealPlan plan) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _activePlan = plan.copyWith(statusNote: '4 planned meals · Approved');
  }
}
