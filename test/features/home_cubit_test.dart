import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:nutrivision_capstone_project/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:nutrivision_capstone_project/features/home/presentation/bloc/home_bloc.dart';

void main() {
  test('loads the dashboard through the repository use case', () async {
    final repository = InMemoryHomeRepository();
    final bloc = HomeBloc(GetHomeDashboard(repository));
    addTearDown(bloc.close);

    final loaded = bloc.stream.firstWhere(
      (state) => state.status == HomeStatus.loaded,
    );
    bloc.add(const HomeDashboardRequested());
    final state = await loaded;

    expect(state.status, HomeStatus.loaded);
    expect(state.dashboard?.nutrition.consumedCalories, 1240);
  });
}
