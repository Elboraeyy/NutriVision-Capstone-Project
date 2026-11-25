import '../../domain/entities/water_intake.dart';

enum WaterStatus { initial, loading, loaded, failure }

class WaterState {
  const WaterState({
    this.status = WaterStatus.initial,
    this.water = const WaterIntake(consumedMl: 0, goalMl: 2000, date: ''),
    this.selectedQuickAddMl = 250,
    this.message,
  });

  final WaterStatus status;
  final WaterIntake water;
  final int selectedQuickAddMl;
  final String? message;

  WaterState copyWith({
    WaterStatus? status,
    WaterIntake? water,
    int? selectedQuickAddMl,
    String? message,
  }) {
    return WaterState(
      status: status ?? this.status,
      water: water ?? this.water,
      selectedQuickAddMl: selectedQuickAddMl ?? this.selectedQuickAddMl,
      message: message,
    );
  }
}
