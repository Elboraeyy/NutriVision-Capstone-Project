import '../entities/home_dashboard.dart';
import '../repositories/home_repository.dart';

class GetHomeDashboard {
  const GetHomeDashboard(this._repository);

  final HomeRepository _repository;

  Future<HomeDashboard> call() => _repository.getDashboard();
}
