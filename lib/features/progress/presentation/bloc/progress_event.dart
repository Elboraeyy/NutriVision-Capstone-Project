import '../../domain/entities/nutrient_comparison.dart';

/// Events dispatched to [ProgressBloc].
sealed class ProgressEvent {
  const ProgressEvent();
}

/// Requests loading the initial progress and insights snapshot.
final class ProgressStarted extends ProgressEvent {
  const ProgressStarted();
}

/// Switches the active date horizon (`today`, `last7Days`, `last30Days`).
final class ProgressRangeChanged extends ProgressEvent {
  const ProgressRangeChanged(this.range);

  final ProgressRange range;
}
