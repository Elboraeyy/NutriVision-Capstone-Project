import 'insight_summary.dart';
import 'nutrient_comparison.dart';
import 'weekly_nutrient_day.dart';

/// Complete progress and insights snapshot for a selected time horizon.
class ProgressSnapshot {
  const ProgressSnapshot({
    required this.range,
    required this.dailyTitle,
    required this.statusChipLabel,
    required this.dateAndSourceLabel,
    required this.comparisons,
    required this.estimateDisclosure,
    required this.weekRangeLabel,
    required this.weeklyDays,
    required this.missingDataLegend,
    required this.dataScopeLabel,
    required this.chartExplanation,
    required this.suggestion,
    required this.pattern,
    required this.transparencyTitle,
    required this.transparencyDescription,
  });

  final ProgressRange range;
  final String dailyTitle;
  final String statusChipLabel;
  final String dateAndSourceLabel;
  final List<NutrientComparison> comparisons;
  final String estimateDisclosure;
  final String weekRangeLabel;
  final List<WeeklyNutrientDay> weeklyDays;
  final String missingDataLegend;
  final String dataScopeLabel;
  final String chartExplanation;
  final InsightSuggestion suggestion;
  final ProgressPattern pattern;
  final String transparencyTitle;
  final String transparencyDescription;
}
