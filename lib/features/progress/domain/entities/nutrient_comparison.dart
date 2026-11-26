/// Time horizon options for nutrition progress and insights.
enum ProgressRange { today, last7Days, last30Days }

extension ProgressRangeX on ProgressRange {
  String get title {
    switch (this) {
      case ProgressRange.today:
        return 'Today · Oct 14';
      case ProgressRange.last7Days:
        return 'Last 7 days';
      case ProgressRange.last30Days:
        return 'Last 30 days';
    }
  }

  String get shortLabel {
    switch (this) {
      case ProgressRange.today:
        return 'Today';
      case ProgressRange.last7Days:
        return '7 days';
      case ProgressRange.last30Days:
        return '30 days';
    }
  }
}

/// Pure business comparison for a single tracked nutrient against its target.
class NutrientComparison {
  const NutrientComparison({
    required this.id,
    required this.label,
    required this.unit,
    required this.consumed,
    required this.target,
    required this.scaleOriginLabel,
  });

  final String id;
  final String label;
  final String unit;
  final int consumed;
  final int target;
  final String scaleOriginLabel;

  double get progress => target <= 0 ? 0 : (consumed / target).clamp(0.0, 1.0);

  int get percentage => (progress * 100).round();

  int get remaining => target > consumed ? target - consumed : 0;

  bool get isMet => consumed >= target;

  String get loggedDisplay => '$consumed $unit';

  String get targetDisplay => '$target $unit target';
}
