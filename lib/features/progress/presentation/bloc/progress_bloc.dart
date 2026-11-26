import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/nutrient_comparison.dart';
import '../../domain/usecases/get_progress_snapshot.dart';
import 'progress_event.dart';
import 'progress_state.dart';

export 'progress_event.dart';
export 'progress_state.dart';

/// Bloc orchestrating Progress and Insights loading across time ranges.
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc({required this.getProgressSnapshot})
    : super(const ProgressState()) {
    on<ProgressStarted>(_onStarted);
    on<ProgressRangeChanged>(_onRangeChanged);
  }

  final GetProgressSnapshot getProgressSnapshot;

  Future<void> _onStarted(
    ProgressStarted event,
    Emitter<ProgressState> emit,
  ) async {
    await _loadRange(state.selectedRange, emit);
  }

  Future<void> _onRangeChanged(
    ProgressRangeChanged event,
    Emitter<ProgressState> emit,
  ) async {
    await _loadRange(event.range, emit);
  }

  Future<void> _loadRange(
    ProgressRange range,
    Emitter<ProgressState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProgressStatus.loading,
        selectedRange: range,
        clearError: true,
      ),
    );

    try {
      final snapshot = await getProgressSnapshot(range);
      emit(
        state.copyWith(
          status: ProgressStatus.success,
          selectedRange: range,
          snapshot: snapshot,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProgressStatus.failure,
          errorMessage:
              'Unable to load your progress trends. Please try again.',
        ),
      );
    }
  }
}
