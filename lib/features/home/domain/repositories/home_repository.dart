import '../entities/home_dashboard.dart';

abstract interface class HomeRepository {
  Future<HomeDashboard> getDashboard();
}
