import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/features/water_tracker/data/datasources/water_local_data_source.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/data/repositories/water_repository_impl.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/domain/usecases/add_water.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/domain/usecases/get_today_water.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/presentation/bloc/water_bloc.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/presentation/screens/water_tracker_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WaterLocalDataSource', () {
    test('initializes with 0 ml consumed and default 2000 ml goal', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SharedPreferencesWaterLocalDataSource();

      final result = await dataSource.getTodayWater();

      expect(result.consumedMl, 0);
      expect(result.goalMl, 2000);
      expect(result.progress, 0.0);
      expect(result.remainingMl, 2000);
    });

    test('resets consumed ml if saved date is from a previous day', () async {
      SharedPreferences.setMockInitialValues({
        'water_tracker_consumed_ml': 1500,
        'water_tracker_goal_ml': 2000,
        'water_tracker_date': '2020-01-01',
      });
      final dataSource = SharedPreferencesWaterLocalDataSource();

      final result = await dataSource.getTodayWater();

      expect(result.consumedMl, 0);
      expect(result.date, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });

    test('adds water and persists new total', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SharedPreferencesWaterLocalDataSource();

      final after150 = await dataSource.addWater(150);
      expect(after150.consumedMl, 150);
      expect(after150.remainingMl, 1850);

      final after250 = await dataSource.addWater(250);
      expect(after250.consumedMl, 400);
      expect(after250.remainingMl, 1600);
    });
  });

  group('WaterBloc', () {
    test('loads today water intake and updates on WaterAdded', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SharedPreferencesWaterLocalDataSource();
      final repository = WaterRepositoryImpl(dataSource);
      final bloc = WaterBloc(
        getTodayWater: GetTodayWater(repository),
        addWater: AddWater(repository),
      );
      addTearDown(bloc.close);

      final loadedStateFuture = bloc.stream.firstWhere(
        (state) => state.status == WaterStatus.loaded,
      );
      bloc.add(const WaterTrackerStarted());
      final loadedState = await loadedStateFuture;

      expect(loadedState.water.consumedMl, 0);
      expect(loadedState.water.goalMl, 2000);

      final updatedStateFuture = bloc.stream.firstWhere(
        (state) => state.water.consumedMl == 250,
      );
      bloc.add(const WaterAdded(250));
      final updatedState = await updatedStateFuture;

      expect(updatedState.water.consumedMl, 250);
      expect(updatedState.water.remainingMl, 1750);
      expect(updatedState.selectedQuickAddMl, 250);

      bloc.add(const WaterAdded(150));
      final stateAfter150 = await bloc.stream.firstWhere(
        (state) => state.water.consumedMl == 400,
      );
      expect(stateAfter150.selectedQuickAddMl, 150);

      bloc.add(const QuickAddPresetSelected(500));
      final stateAfterSelect500 = await bloc.stream.firstWhere(
        (state) => state.selectedQuickAddMl == 500,
      );
      expect(stateAfterSelect500.selectedQuickAddMl, 500);
    });
  });

  group('WaterTrackerScreen', () {
    testWidgets('renders all screen sections and elements', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SharedPreferencesWaterLocalDataSource();
      final repository = WaterRepositoryImpl(dataSource);
      final bloc = WaterBloc(
        getTodayWater: GetTodayWater(repository),
        addWater: AddWater(repository),
      )..add(const WaterTrackerStarted());
      addTearDown(bloc.close);

      await tester.binding.setSurfaceSize(const Size(390, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const WaterTrackerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Every sip counts.'), findsOneWidget);
      expect(find.text("Today's water"), findsOneWidget);
      expect(find.text('Quick add'), findsOneWidget);
      expect(find.text('Add your own amount'), findsOneWidget);
      expect(find.text('150 ml'), findsOneWidget);
      expect(find.text('250 ml'), findsOneWidget);
      expect(find.text('500 ml'), findsOneWidget);
      expect(find.text('Add water'), findsOneWidget);
    });

    testWidgets('tapping quick add button updates consumed water', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SharedPreferencesWaterLocalDataSource();
      final repository = WaterRepositoryImpl(dataSource);
      final bloc = WaterBloc(
        getTodayWater: GetTodayWater(repository),
        addWater: AddWater(repository),
      )..add(const WaterTrackerStarted());
      addTearDown(bloc.close);

      await tester.binding.setSurfaceSize(const Size(390, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const WaterTrackerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsWidgets);

      await tester.tap(find.text('250 ml'));
      await tester.pumpAndSettle();

      expect(bloc.state.water.consumedMl, 250);
      expect(find.text('250'), findsOneWidget);
    });
  });
}
