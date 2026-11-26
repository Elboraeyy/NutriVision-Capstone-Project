/// Actionable nutrition insight surfaced from the user's logged gaps.
class InsightSuggestion {
  const InsightSuggestion({
    required this.categoryLabel,
    required this.headline,
    required this.description,
    required this.actionLabel,
    required this.targetRouteName,
  });

  final String categoryLabel;
  final String headline;
  final String description;
  final String actionLabel;
  final String targetRouteName;
}

/// Summary of consistency and emerging logging patterns.
class ProgressPattern {
  const ProgressPattern({
    required this.title,
    required this.coverageLabel,
    required this.description,
    required this.hasEnoughData,
  });

  final String title;
  final String coverageLabel;
  final String description;
  final bool hasEnoughData;
}
