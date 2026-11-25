import '../entities/water_intake.dart';

abstract interface class WaterRepository {
  Future<WaterIntake> getTodayWater();
  Future<WaterIntake> addWater(int amountMl);
  Future<WaterIntake> setGoal(int goalMl);
  Future<WaterIntake> resetTodayWater();
}
