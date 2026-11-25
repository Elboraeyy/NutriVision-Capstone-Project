import '../entities/water_intake.dart';
import '../repositories/water_repository.dart';

class GetTodayWater {
  const GetTodayWater(this._repository);

  final WaterRepository _repository;

  Future<WaterIntake> call() => _repository.getTodayWater();
}
