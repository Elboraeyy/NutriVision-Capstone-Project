import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/features/progress/data/repositories/in_memory_progress_repository.dart';
import 'package:nutrivision_capstone_project/features/progress/domain/entities/nutrient_comparison.dart';
import 'package:nutrivision_capstone_project/features/progress/domain/entities/progress_snapshot.dart';
import 'package:nutrivision_capstone_project/features/progress/domain/repositories/progress_repository.dart';
import 'package:nutrivision_capstone_project/features/progress/domain/usecases/get_progress_snapshot.dart';
import 'package:nutrivision_capstone_project/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:nutrivision_capstone_project/features/progress/presentation/screens/insights_screen.dart';
import 'package:nutrivision_capstone_project/features/progress/presentation/screens/progress_screen.dart';

class _FailingProgressRepository implements ProgressRepository {
  @override
  Future<ProgressSnapshot> getProgress(ProgressRange range) async {
    throw Exception('Network unavailable');
  }
}

void main() {
  group('InMemoryProgressRepository', () {
    late InMemoryProgressRepository repository;

    setUp(() {
      repository = InMemoryProgressRepository();
    });

    test('returns today snapshot matching daily goals', () async {
      final snapshot = await repository.getProgress(ProgressRange.today);

      expect(snapshot.range, ProgressRange.today);
      expect(snapshot.dailyTitle, 'Daily intake');
      expect(snapshot.comparisons.length, 4);
      expect(snapshot.comparisons.first.consumed, 1240);
      expect(snapshot.comparisons.first.target, 2000);
      expect(snapshot.weeklyDays.length, 7);
      expect(snapshot.weeklyDays.last.isToday, isTrue);
      expect(snapshot.pattern.hasEnoughData, isFalse);
    });

    test('returns populated weekly & monthly snapshots', () async {
      final week = await repository.getProgress(ProgressRange.last7Days);
      final month = await repository.getProgress(ProgressRange.last30Days);

      expect(week.dailyTitle, 'Daily average');
      expect(week.weeklyDays.where((d) => d.hasData).length, 5);
      expect(week.pattern.hasEnoughData, isTrue);

      expect(month.dailyTitle, '30-day average');
      expect(month.pattern.coverageLabel, contains('22 of 30 days'));
    });
  });

  group('ProgressBloc', () {
    late InMemoryProgressRepository repository;
    late ProgressBloc bloc;

    setUp(() {
      repository = InMemoryProgressRepository();
      bloc = ProgressBloc(getProgressSnapshot: GetProgressSnapshot(repository));
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has expected defaults', () {
      expect(bloc.state.status, ProgressStatus.initial);
      expect(bloc.state.selectedRange, ProgressRange.today);
      expect(bloc.state.snapshot, isNull);
    });

    test('emits loading then success on ProgressStarted', () async {
      bloc.add(const ProgressStarted());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProgressState>((s) => s.status == ProgressStatus.loading),
          predicate<ProgressState>(
            (s) =>
                s.status == ProgressStatus.success &&
                s.snapshot != null &&
                s.snapshot!.comparisons.length == 4,
          ),
        ]),
      );
    });

    test(
      'updates selectedRange and snapshot on ProgressRangeChanged',
      () async {
        bloc.add(const ProgressStarted());
        await bloc.stream.firstWhere((s) => s.status == ProgressStatus.success);

        bloc.add(const ProgressRangeChanged(ProgressRange.last7Days));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<ProgressState>(
              (s) =>
                  s.status == ProgressStatus.loading &&
                  s.selectedRange == ProgressRange.last7Days,
            ),
            predicate<ProgressState>(
              (s) =>
                  s.status == ProgressStatus.success &&
                  s.snapshot?.range == ProgressRange.last7Days &&
                  s.snapshot?.dailyTitle == 'Daily average',
            ),
          ]),
        );
      },
    );

    test('emits failure when repository throws', () async {
      final failingBloc = ProgressBloc(
        getProgressSnapshot: GetProgressSnapshot(_FailingProgressRepository()),
      );
      addTearDown(failingBloc.close);

      failingBloc.add(const ProgressStarted());

      await expectLater(
        failingBloc.stream,
        emitsInOrder([
          predicate<ProgressState>((s) => s.status == ProgressStatus.loading),
          predicate<ProgressState>(
            (s) => s.status == ProgressStatus.failure && s.errorMessage != null,
          ),
        ]),
      );
    });
  });

  group('Progress & Insights Widget Tests', () {
    Widget wrapScreen(Widget child) {
      return BlocProvider<ProgressBloc>(
        create: (_) => ProgressBloc(
          getProgressSnapshot: GetProgressSnapshot(
            InMemoryProgressRepository(),
          ),
        )..add(const ProgressStarted()),
        child: MaterialApp(theme: AppTheme.light, home: child),
      );
    }

    testWidgets('ProgressScreen renders floating daily card and weekly table', (
      tester,
    ) async {
      await tester.pumpWidget(wrapScreen(const ProgressScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Progress'), findsWidgets);
      expect(find.text('Daily intake'), findsOneWidget);
      expect(find.text('On track'), findsOneWidget);
      expect(find.text('This week'), findsOneWidget);
      expect(find.text('View Insights & Patterns'), findsOneWidget);
    });

    testWidgets('ProgressScreen adapts cleanly on narrow 360x640 viewport', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(wrapScreen(const ProgressScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Daily intake'), findsOneWidget);
    });

    testWidgets(
      'InsightsScreen renders selector, comparisons, suggestion, and updates range',
      (tester) async {
        await tester.pumpWidget(wrapScreen(const InsightsScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Insights'), findsOneWidget);
        expect(find.text('Today · Oct 14'), findsOneWidget);
        expect(find.text('Nutrition comparisons'), findsOneWidget);
        expect(find.text('PROTEIN SUGGESTION'), findsOneWidget);
        expect(find.text('Emerging patterns'), findsOneWidget);

        await tester.tap(find.text('Today · Oct 14'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Last 7 days'));
        await tester.pumpAndSettle();

        expect(find.text('Last 7 days'), findsOneWidget);
        expect(find.text('Weekly consistency'), findsOneWidget);
      },
    );
  });
}
