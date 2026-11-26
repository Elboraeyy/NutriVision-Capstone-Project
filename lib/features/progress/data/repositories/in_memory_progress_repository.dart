import '../../domain/entities/insight_summary.dart';
import '../../domain/entities/nutrient_comparison.dart';
import '../../domain/entities/progress_snapshot.dart';
import '../../domain/entities/weekly_nutrient_day.dart';
import '../../domain/repositories/progress_repository.dart';

/// Placeholder in-memory implementation of [ProgressRepository] aligned with
/// the NutriVision Figma Progress (`206:6306`) & Insights (`206:6202`) data.
class InMemoryProgressRepository implements ProgressRepository {
  @override
  Future<ProgressSnapshot> getProgress(ProgressRange range) async {
    switch (range) {
      case ProgressRange.today:
        return _todaySnapshot;
      case ProgressRange.last7Days:
        return _last7DaysSnapshot;
      case ProgressRange.last30Days:
        return _last30DaysSnapshot;
    }
  }

  static const _todayComparisons = [
    NutrientComparison(
      id: 'calories',
      label: 'Calories',
      unit: 'kcal',
      consumed: 1240,
      target: 2000,
      scaleOriginLabel: '0 kcal',
    ),
    NutrientComparison(
      id: 'protein',
      label: 'Protein',
      unit: 'g',
      consumed: 85,
      target: 120,
      scaleOriginLabel: '0 g',
    ),
    NutrientComparison(
      id: 'carbs',
      label: 'Carbohydrates',
      unit: 'g',
      consumed: 135,
      target: 245,
      scaleOriginLabel: '0 g',
    ),
    NutrientComparison(
      id: 'fat',
      label: 'Fat',
      unit: 'g',
      consumed: 40,
      target: 60,
      scaleOriginLabel: '0 g',
    ),
  ];

  static const _todayWeeklyDays = [
    WeeklyNutrientDay(shortDay: 'M', isToday: false, hasData: false),
    WeeklyNutrientDay(shortDay: 'T', isToday: false, hasData: false),
    WeeklyNutrientDay(shortDay: 'W', isToday: false, hasData: false),
    WeeklyNutrientDay(shortDay: 'T', isToday: false, hasData: false),
    WeeklyNutrientDay(shortDay: 'F', isToday: false, hasData: false),
    WeeklyNutrientDay(shortDay: 'S', isToday: false, hasData: false),
    WeeklyNutrientDay(
      shortDay: 'Today',
      isToday: true,
      hasData: true,
      calories: 1240,
      protein: 85,
      carbs: 135,
      fat: 40,
    ),
  ];

  static const _todaySnapshot = ProgressSnapshot(
    range: ProgressRange.today,
    dailyTitle: 'Daily intake',
    statusChipLabel: 'On track',
    dateAndSourceLabel: 'Wednesday, Oct 14 · From logged meals',
    comparisons: _todayComparisons,
    estimateDisclosure:
        'Totals reflect logged meals so far today and saved daily targets.',
    weekRangeLabel: 'Oct 8 – Oct 14',
    weeklyDays: _todayWeeklyDays,
    missingDataLegend:
        'Dashes indicate days with no logged meals yet. Today shows current totals.',
    dataScopeLabel:
        'Comparing today’s logged meals against your daily nutrition goals.',
    chartExplanation:
        'Bars represent your current intake ratio toward each daily goal.',
    suggestion: InsightSuggestion(
      categoryLabel: 'PROTEIN SUGGESTION',
      headline: 'Close your 35 g protein gap',
      description:
          'You are at 85 g of your 120 g target with 760 kcal left. Adding lean salmon, grilled chicken, or Greek yogurt for dinner closes the gap smoothly.',
      actionLabel: 'Browse high-protein ideas',
      targetRouteName: 'discover',
    ),
    pattern: ProgressPattern(
      title: 'Emerging patterns',
      coverageLabel: '1 of 7 days logged',
      description:
          'Log meals across a few more days to unlock multi-day timing, macro balance, and consistency patterns.',
      hasEnoughData: false,
    ),
    transparencyTitle: 'How insights are calculated',
    transparencyDescription:
        'NutriVision compares only the meals you log with your personalized calorie and macro targets—no guesswork or hidden estimates.',
  );

  static const _last7DaysSnapshot = ProgressSnapshot(
    range: ProgressRange.last7Days,
    dailyTitle: 'Daily average',
    statusChipLabel: 'Steady',
    dateAndSourceLabel: 'Oct 8 – Oct 14 · 5 of 7 days logged',
    comparisons: [
      NutrientComparison(
        id: 'calories',
        label: 'Calories',
        unit: 'kcal',
        consumed: 1840,
        target: 2000,
        scaleOriginLabel: '0 kcal avg',
      ),
      NutrientComparison(
        id: 'protein',
        label: 'Protein',
        unit: 'g',
        consumed: 108,
        target: 120,
        scaleOriginLabel: '0 g avg',
      ),
      NutrientComparison(
        id: 'carbs',
        label: 'Carbohydrates',
        unit: 'g',
        consumed: 215,
        target: 245,
        scaleOriginLabel: '0 g avg',
      ),
      NutrientComparison(
        id: 'fat',
        label: 'Fat',
        unit: 'g',
        consumed: 54,
        target: 60,
        scaleOriginLabel: '0 g avg',
      ),
    ],
    estimateDisclosure:
        'Averages are calculated only across the 5 days with logged meals.',
    weekRangeLabel: 'Oct 8 – Oct 14',
    weeklyDays: [
      WeeklyNutrientDay(
        shortDay: 'M',
        isToday: false,
        hasData: true,
        calories: 1920,
        protein: 112,
        carbs: 220,
        fat: 58,
      ),
      WeeklyNutrientDay(
        shortDay: 'T',
        isToday: false,
        hasData: true,
        calories: 1850,
        protein: 118,
        carbs: 205,
        fat: 55,
      ),
      WeeklyNutrientDay(shortDay: 'W', isToday: false, hasData: false),
      WeeklyNutrientDay(
        shortDay: 'T',
        isToday: false,
        hasData: true,
        calories: 2040,
        protein: 122,
        carbs: 240,
        fat: 62,
      ),
      WeeklyNutrientDay(
        shortDay: 'F',
        isToday: false,
        hasData: true,
        calories: 1790,
        protein: 104,
        carbs: 210,
        fat: 52,
      ),
      WeeklyNutrientDay(shortDay: 'S', isToday: false, hasData: false),
      WeeklyNutrientDay(
        shortDay: 'Today',
        isToday: true,
        hasData: true,
        calories: 1240,
        protein: 85,
        carbs: 135,
        fat: 40,
      ),
    ],
    missingDataLegend:
        'Days with logged entries contribute to your 7-day average.',
    dataScopeLabel:
        'Averaged across 5 logged days compared with your daily nutrition targets.',
    chartExplanation:
        'Protein sits within 10% of goal on most logged days this week.',
    suggestion: InsightSuggestion(
      categoryLabel: 'PROTEIN SUGGESTION',
      headline: '12 g daily average gap',
      description:
          'Breakfast protein averages 18 g across your week. Boosting morning protein by 15 g keeps evening hunger lower and hits 120 g effortlessly.',
      actionLabel: 'Plan protein breakfasts',
      targetRouteName: 'meal-plan',
    ),
    pattern: ProgressPattern(
      title: 'Weekly consistency',
      coverageLabel: '5 of 7 days logged · 71% coverage',
      description:
          'Calories stay within 8% of your 2,000 kcal goal on logged weekdays, with lightest tracking on Saturday.',
      hasEnoughData: true,
    ),
    transparencyTitle: 'How insights are calculated',
    transparencyDescription:
        'Unlogged days are excluded from weekly averages so missed logs never artificially pull your nutrition numbers down.',
  );

  static const _last30DaysSnapshot = ProgressSnapshot(
    range: ProgressRange.last30Days,
    dailyTitle: '30-day average',
    statusChipLabel: 'Balanced',
    dateAndSourceLabel: 'Sep 15 – Oct 14 · 22 of 30 days logged',
    comparisons: [
      NutrientComparison(
        id: 'calories',
        label: 'Calories',
        unit: 'kcal',
        consumed: 1910,
        target: 2000,
        scaleOriginLabel: '0 kcal avg',
      ),
      NutrientComparison(
        id: 'protein',
        label: 'Protein',
        unit: 'g',
        consumed: 114,
        target: 120,
        scaleOriginLabel: '0 g avg',
      ),
      NutrientComparison(
        id: 'carbs',
        label: 'Carbohydrates',
        unit: 'g',
        consumed: 228,
        target: 245,
        scaleOriginLabel: '0 g avg',
      ),
      NutrientComparison(
        id: 'fat',
        label: 'Fat',
        unit: 'g',
        consumed: 56,
        target: 60,
        scaleOriginLabel: '0 g avg',
      ),
    ],
    estimateDisclosure:
        '30-day averages combine 22 active logging days against current goals.',
    weekRangeLabel: 'Oct 8 – Oct 14',
    weeklyDays: _todayWeeklyDays,
    missingDataLegend:
        'Showing current week breakdown alongside your 30-day macro averages.',
    dataScopeLabel:
        'Monthly trend across 22 logged days compared against your daily goals.',
    chartExplanation:
        'All four tracked targets stay within 5%–7% of your long-term goals.',
    suggestion: InsightSuggestion(
      categoryLabel: 'PROTEIN SUGGESTION',
      headline: '95% monthly protein adherence',
      description:
          'You consistently average 114 g of protein per logged day—just 6 g shy of target. Keeping a high-protein snack ready covers the difference.',
      actionLabel: 'Explore healthy snacks',
      targetRouteName: 'discover',
    ),
    pattern: ProgressPattern(
      title: 'Monthly rhythm',
      coverageLabel: '22 of 30 days logged · 3-day active streak',
      description:
          'Your strongest adherence happens Monday through Thursday when planned meals are pre-selected.',
      hasEnoughData: true,
    ),
    transparencyTitle: 'How insights are calculated',
    transparencyDescription:
        'Long-term trends summarize only verified meal logs and update immediately whenever you edit or add entries.',
  );
}
