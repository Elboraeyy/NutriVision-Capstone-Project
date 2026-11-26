import '../entities/nutrient_comparison.dart';
import '../entities/progress_snapshot.dart';
import '../repositories/progress_repository.dart';

/// Loads nutrition progress and insights for a given [ProgressRange].
class GetProgressSnapshot {
  const GetProgressSnapshot(this._repository);

  final ProgressRepository _repository;

  Future<ProgressSnapshot> call(ProgressRange range) {
    return _repository.getProgress(range);
  }
}
