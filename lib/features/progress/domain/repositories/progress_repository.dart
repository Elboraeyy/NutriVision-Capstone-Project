import '../entities/nutrient_comparison.dart';
import '../entities/progress_snapshot.dart';

/// Abstract backend-agnostic contract for loading nutrition progress & insights.
abstract interface class ProgressRepository {
  Future<ProgressSnapshot> getProgress(ProgressRange range);
}
