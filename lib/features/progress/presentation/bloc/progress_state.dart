import '../../domain/entities/nutrient_comparison.dart';
import '../../domain/entities/progress_snapshot.dart';

/// Lifecycle states for progress and insights data loading.
enum ProgressStatus { initial, loading, success, failure }

/// Immutable state held by [ProgressBloc].
class ProgressState {
  const ProgressState({
    this.status = ProgressStatus.initial,
    this.selectedRange = ProgressRange.today,
    this.snapshot,
    this.errorMessage,
  });

  final ProgressStatus status;
  final ProgressRange selectedRange;
  final ProgressSnapshot? snapshot;
  final String? errorMessage;

  ProgressState copyWith({
    ProgressStatus? status,
    ProgressRange? selectedRange,
    ProgressSnapshot? snapshot,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProgressState(
      status: status ?? this.status,
      selectedRange: selectedRange ?? this.selectedRange,
      snapshot: snapshot ?? this.snapshot,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
