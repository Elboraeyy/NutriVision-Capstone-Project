class WaterIntake {
  const WaterIntake({
    required this.consumedMl,
    required this.goalMl,
    required this.date,
  });

  final int consumedMl;
  final int goalMl;
  final String date;

  double get progress =>
      goalMl > 0 ? (consumedMl / goalMl).clamp(0.0, 1.0) : 0.0;

  double get percentage =>
      goalMl > 0 ? ((consumedMl / goalMl) * 100).clamp(0.0, 100.0) : 0.0;

  int get remainingMl => (goalMl - consumedMl).clamp(0, goalMl);

  WaterIntake copyWith({int? consumedMl, int? goalMl, String? date}) {
    return WaterIntake(
      consumedMl: consumedMl ?? this.consumedMl,
      goalMl: goalMl ?? this.goalMl,
      date: date ?? this.date,
    );
  }
}
