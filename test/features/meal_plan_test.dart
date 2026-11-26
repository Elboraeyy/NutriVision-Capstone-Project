import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/data/repositories/in_memory_meal_plan_repository.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/domain/usecases/approve_meal_plan.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/domain/usecases/cycle_alternative_meal.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/domain/usecases/generate_ai_meal_plan.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/domain/usecases/get_meal_plan.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/presentation/bloc/meal_plan_bloc.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/presentation/screens/ai_plan_generate_screen.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/presentation/screens/edit_meal_plan_screen.dart';
import 'package:nutrivision_capstone_project/features/meal_plan/presentation/screens/meal_plan_screen.dart';

void main() {
  group('InMemoryMealPlanRepository', () {
    late InMemoryMealPlanRepository repository;

    setUp(() {
      repository = InMemoryMealPlanRepository();
    });

    test('getMealPlanForDate returns active plan with 4 meals', () async {
      final now = DateTime.now();
      final plan = await repository.getMealPlanForDate(now);

      expect(plan.meals.length, 4);
      expect(plan.isToday, isTrue);
      expect(plan.nutrition.calories, 1795);
      expect(plan.nutrition.targetCalories, 2000);
      expect(plan.meals.first.title, 'Berry & yogurt oats');
    });

    test(
      'generateAiPlan creates a draft with recalculated nutrition',
      () async {
        final draft = await repository.generateAiPlan(
          goal: 'Fat loss & muscle retain (1,850 kcal/day)',
          durationDays: 3,
          availableFoods: ['Chicken breast', 'Salmon'],
          mealPattern: '3 meals + 1 snack',
        );

        expect(draft.meals.length, 4);
        expect(draft.nutrition.calories, greaterThan(0));
        expect(draft.statusNote, contains('AI generated draft'));
      },
    );

    test('cycleAlternativeMeal cycles to a different meal option', () async {
      final initial = await repository.getMealPlanForDate(DateTime.now());
      final alt = await repository.cycleAlternativeMeal(initial.meals.first.id);

      expect(alt.type, initial.meals.first.type);
    });

    test('approvePlan saves the plan and updates status note', () async {
      final plan = await repository.getMealPlanForDate(DateTime.now());
      await repository.approvePlan(plan);

      final updated = await repository.getMealPlanForDate(DateTime.now());
      expect(updated.statusNote, contains('Approved'));
    });
  });

  group('MealPlanBloc', () {
    late InMemoryMealPlanRepository repository;
    late MealPlanBloc bloc;

    setUp(() {
      repository = InMemoryMealPlanRepository();
      bloc = MealPlanBloc(
        getMealPlan: GetMealPlan(repository),
        generateAiMealPlan: GenerateAiMealPlan(repository),
        cycleAlternativeMeal: CycleAlternativeMeal(repository),
        approveMealPlan: ApproveMealPlan(repository),
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has correct defaults', () {
      expect(bloc.state.status, MealPlanStatus.initial);
      expect(bloc.state.activePlan, isNull);
      expect(bloc.state.draftPlan, isNull);
    });

    test('emits success when MealPlanStarted is dispatched', () async {
      bloc.add(const MealPlanStarted());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<MealPlanState>((s) => s.status == MealPlanStatus.loading),
          predicate<MealPlanState>(
            (s) =>
                s.status == MealPlanStatus.success &&
                s.activePlan != null &&
                s.activePlan!.meals.length == 4,
          ),
        ]),
      );
    });

    test('emits draft plan on MealPlanAiGenerationRequested', () async {
      bloc.add(const MealPlanStarted());
      await bloc.stream.firstWhere((s) => s.status == MealPlanStatus.success);

      bloc.add(const MealPlanAiGenerationRequested());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<MealPlanState>((s) => s.isGeneratingAi == true),
          predicate<MealPlanState>(
            (s) =>
                s.isGeneratingAi == false &&
                s.draftPlan != null &&
                s.feedbackMessage != null,
          ),
        ]),
      );
    });
  });

  group('Meal Plan Screens Widget Tests', () {
    late InMemoryMealPlanRepository repository;
    late MealPlanBloc bloc;

    setUp(() async {
      repository = InMemoryMealPlanRepository();
      bloc = MealPlanBloc(
        getMealPlan: GetMealPlan(repository),
        generateAiMealPlan: GenerateAiMealPlan(repository),
        cycleAlternativeMeal: CycleAlternativeMeal(repository),
        approveMealPlan: ApproveMealPlan(repository),
      );
      bloc.add(const MealPlanStarted());
      await bloc.stream.firstWhere((s) => s.status == MealPlanStatus.success);
    });

    tearDown(() {
      bloc.close();
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider<MealPlanBloc>.value(value: bloc, child: child),
      );
    }

    testWidgets('MealPlanScreen renders nutrition card and meals', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const MealPlanScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Planned nutrition'), findsOneWidget);
      expect(find.text('Berry & yogurt oats'), findsOneWidget);
      expect(find.text('Chicken & quinoa bowl'), findsOneWidget);
      expect(find.text('Generate plan'), findsOneWidget);
      expect(find.text('Edit plan'), findsOneWidget);
    });

    testWidgets('AiPlanGenerateScreen renders Start with you section', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const AiPlanGenerateScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Make room for good food.'), findsOneWidget);
      expect(find.text('Start with you'), findsOneWidget);
      expect(find.text('Generate draft plan'), findsOneWidget);
      expect(find.text('1 day'), findsOneWidget);
    });

    testWidgets('EditMealPlanScreen renders planned meals and save action', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const EditMealPlanScreen()));
      await tester.pumpAndSettle();

      expect(find.text('A good day ahead.'), findsOneWidget);
      expect(find.text('On your menu'), findsOneWidget);
      expect(find.text('Save plan changes'), findsOneWidget);
    });
  });
}
