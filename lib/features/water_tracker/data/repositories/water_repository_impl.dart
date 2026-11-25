import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_repository.dart';
import '../datasources/water_local_data_source.dart';

class WaterRepositoryImpl implements WaterRepository {
  const WaterRepositoryImpl(this._localDataSource);

  final WaterLocalDataSource _localDataSource;

  @override
  Future<WaterIntake> getTodayWater() => _localDataSource.getTodayWater();

  @override
  Future<WaterIntake> addWater(int amountMl) =>
      _localDataSource.addWater(amountMl);

  @override
  Future<WaterIntake> setGoal(int goalMl) => _localDataSource.setGoal(goalMl);

  @override
  Future<WaterIntake> resetTodayWater() => _localDataSource.resetTodayWater();
}
