import '../../domain/entities/water_intake.dart';

class WaterIntakeModel extends WaterIntake {
  const WaterIntakeModel({
    required super.consumedMl,
    required super.goalMl,
    required super.date,
  });

  factory WaterIntakeModel.fromEntity(WaterIntake entity) {
    return WaterIntakeModel(
      consumedMl: entity.consumedMl,
      goalMl: entity.goalMl,
      date: entity.date,
    );
  }

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      consumedMl: json['consumedMl'] as int? ?? 0,
      goalMl: json['goalMl'] as int? ?? 2000,
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'consumedMl': consumedMl, 'goalMl': goalMl, 'date': date};
  }

  @override
  WaterIntakeModel copyWith({int? consumedMl, int? goalMl, String? date}) {
    return WaterIntakeModel(
      consumedMl: consumedMl ?? this.consumedMl,
      goalMl: goalMl ?? this.goalMl,
      date: date ?? this.date,
    );
  }
}
