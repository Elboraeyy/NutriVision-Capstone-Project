import '../entities/water_intake.dart';
import '../repositories/water_repository.dart';

class AddWater {
  const AddWater(this._repository);

  final WaterRepository _repository;

  Future<WaterIntake> call(int amountMl) => _repository.addWater(amountMl);
}
