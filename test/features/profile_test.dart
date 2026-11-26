import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_in.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_out.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_up.dart';
import 'package:nutrivision_capstone_project/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:nutrivision_capstone_project/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/entities/onboarding_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/in_memory_profile_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/daily_nutrition_targets.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/notification_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/privacy_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/user_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/delete_account_data.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_user_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/request_data_export.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/update_goals_and_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/update_notification_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/update_privacy_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/goals_preferences_screen.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/notifications_settings_screen.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/privacy_data_screen.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/profile_screen.dart';

class _FailingProfileRepository implements ProfileRepository {
  @override
  Future<void> deleteAccountData() async => throw Exception('Delete failed');

  @override
  Future<UserProfile> getProfile() async => throw Exception('Load failed');

  @override
  Future<void> requestDataExport() async => throw Exception('Export failed');

  @override
  Future<UserProfile> updateGoalsAndPreferences(UserProfile profile) async =>
      throw Exception('Save failed');

  @override
  Future<UserProfile> updateNotifications(
    NotificationPreferences notifications,
  ) async => throw Exception('Save failed');

  @override
  Future<UserProfile> updatePrivacy(PrivacyPreferences privacy) async =>
      throw Exception('Save failed');
}

ProfileBloc _buildProfileBloc(ProfileRepository repository) {
  return ProfileBloc(
    getUserProfile: GetUserProfile(repository),
    updateGoalsAndPreferences: UpdateGoalsAndPreferences(repository),
    updateNotificationPreferences: UpdateNotificationPreferences(repository),
    updatePrivacyPreferences: UpdatePrivacyPreferences(repository),
    requestDataExport: RequestDataExport(repository),
    deleteAccountData: DeleteAccountData(repository),
  );
}

void main() {
  group('InMemoryProfileRepository & Use Cases', () {
    test('merges onboarding preferences and syncs updates back', () async {
      final onboarding = InMemoryOnboardingRepository();
      await onboarding.saveDraft(
        const OnboardingProfile(
          goal: 'Build Muscle',
          dietaryPreferences: {'Vegetarian'},
          favoriteFoods: {'Lentils'},
          allergies: {'Soy'},
        ),
      );
      final repository = InMemoryProfileRepository(
        onboardingRepository: onboarding,
      );

      final loaded = await repository.getProfile();
      expect(loaded.goal, 'Build Muscle');
      expect(loaded.dietaryPattern, 'Vegetarian');
      expect(loaded.favoriteFoods, {'Lentils'});
      expect(loaded.allergies, {'Soy'});

      await repository.updateGoalsAndPreferences(
        loaded.copyWith(goal: 'Maintain Weight', allergies: {'Peanuts'}),
      );
      expect(onboarding.draft.goal, 'Maintain Weight');
      expect(onboarding.draft.allergies, {'Peanuts'});
    });

    test('UpdateGoalsAndPreferences validates calorie bounds', () {
      final repository = InMemoryProfileRepository();
      final useCase = UpdateGoalsAndPreferences(repository);

      expect(
        () => useCase(
          const UserProfile(dailyTargets: DailyNutritionTargets(calories: 300)),
        ),
        throwsArgumentError,
      );
    });
  });

  group('ProfileBloc', () {
    late InMemoryProfileRepository repository;
    late ProfileBloc bloc;

    setUp(() {
      repository = InMemoryProfileRepository();
      bloc = _buildProfileBloc(repository);
    });

    tearDown(() => bloc.close());

    test('loads profile on ProfileLoadRequested', () async {
      bloc.add(const ProfileLoadRequested());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>(
            (s) => s.loadStatus == ProfileLoadStatus.loading,
          ),
          predicate<ProfileState>(
            (s) =>
                s.loadStatus == ProfileLoadStatus.ready &&
                s.profile.displayName == 'Maya',
          ),
        ]),
      );
    });

    test(
      'updates goals, notifications, privacy consent, export, and delete',
      () async {
        bloc.add(const ProfileLoadRequested());
        await bloc.stream.firstWhere(
          (s) => s.loadStatus == ProfileLoadStatus.ready,
        );

        bloc.add(
          ProfileGoalsAndPreferencesSaved(
            bloc.state.profile.copyWith(goal: 'Build Muscle'),
          ),
        );
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<ProfileState>(
              (s) =>
                  s.actionStatus == ProfileActionStatus.goalsSaved &&
                  s.profile.goal == 'Build Muscle',
            ),
          ),
        );

        bloc.add(
          const ProfileNotificationsSaved(
            NotificationPreferences(
              pushPermission: 'Enabled',
              mealReminderSchedule: 'All 3 meals',
            ),
          ),
        );
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<ProfileState>(
              (s) =>
                  s.actionStatus == ProfileActionStatus.notificationsSaved &&
                  s.profile.notifications.pushPermission == 'Enabled',
            ),
          ),
        );

        bloc.add(const ProfileMealPhotoConsentToggled(false));
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<ProfileState>(
              (s) =>
                  s.actionStatus == ProfileActionStatus.privacySaved &&
                  !s.profile.privacy.allowMealPhotoProcessing,
            ),
          ),
        );

        bloc.add(const ProfileDataExportRequested());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<ProfileState>(
              (s) =>
                  s.actionStatus == ProfileActionStatus.exportRequested &&
                  s.profile.privacy.lastExportRequestedAt != null,
            ),
          ),
        );

        bloc.add(const ProfileAccountDeletionRequested());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<ProfileState>(
              (s) => s.actionStatus == ProfileActionStatus.accountDeleted,
            ),
          ),
        );
      },
    );

    test('emits failure when repository throws', () async {
      final failingBloc = _buildProfileBloc(_FailingProfileRepository());
      addTearDown(failingBloc.close);

      failingBloc.add(const ProfileLoadRequested());

      await expectLater(
        failingBloc.stream,
        emitsThrough(
          predicate<ProfileState>(
            (s) =>
                s.loadStatus == ProfileLoadStatus.failure && s.message != null,
          ),
        ),
      );
    });
  });

  group('Profile Widget Tests', () {
    Widget wrapScreen(Widget child, {AuthSessionBloc? authBloc}) {
      final repo = InMemoryAuthRepository();
      final effectiveAuthBloc =
          authBloc ??
          AuthSessionBloc(
            repository: repo,
            signIn: SignIn(repo),
            signUp: SignUp(repo),
            signOut: SignOut(repo),
          );
      return MultiBlocProvider(
        providers: [
          BlocProvider<AuthSessionBloc>.value(value: effectiveAuthBloc),
          BlocProvider<ProfileBloc>(
            create: (_) =>
                _buildProfileBloc(InMemoryProfileRepository())
                  ..add(const ProfileLoadRequested()),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: child),
      );
    }

    testWidgets(
      'ProfileScreen renders identity card, settings options, and sign out dialog',
      (tester) async {
        await tester.pumpWidget(wrapScreen(const ProfileScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Profile & settings.'), findsOneWidget);
        expect(find.text('Maya'), findsOneWidget);
        expect(find.text('Account settings'), findsOneWidget);
        expect(find.text('Goals & Dietary Preferences'), findsOneWidget);
        expect(find.text('Notifications Settings'), findsOneWidget);
        expect(find.text('Privacy & Data Management'), findsOneWidget);
        expect(find.text('Sign out'), findsOneWidget);

        await tester.ensureVisible(find.text('Sign out'));
        await tester.tap(find.text('Sign out'));
        await tester.pumpAndSettle();

        expect(find.text('Sign out?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.text('Sign out?'), findsNothing);
      },
    );

    testWidgets('ProfileScreen adapts cleanly on narrow 360x640 viewport', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(wrapScreen(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Maya'), findsOneWidget);
    });

    testWidgets('GoalsPreferencesScreen renders sections and saves changes', (
      tester,
    ) async {
      await tester.pumpWidget(wrapScreen(const GoalsPreferencesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Your goal'), findsOneWidget);
      expect(find.text('Eat Healthier'), findsOneWidget);
      expect(find.text('Allergies'), findsOneWidget);
      expect(find.text('Peanuts'), findsOneWidget);
      expect(find.text('Your daily targets'), findsOneWidget);
      expect(find.text('2,000'), findsWidgets);
      expect(find.text('Dietary pattern'), findsOneWidget);
      expect(find.text('Food preferences'), findsOneWidget);

      await tester.ensureVisible(find.text('Save changes'));
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(find.text('Goals & preferences saved.'), findsOneWidget);
    });

    testWidgets(
      'NotificationsSettingsScreen renders cards and saves preferences',
      (tester) async {
        await tester.pumpWidget(
          wrapScreen(const NotificationsSettingsScreen()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Device permission'), findsOneWidget);
        expect(find.text('Meal logging reminders'), findsOneWidget);
        expect(find.text('Water reminders'), findsWidgets);
        expect(find.text('Sound & quiet hours'), findsOneWidget);

        await tester.ensureVisible(find.text('Save changes'));
        await tester.tap(find.text('Save changes'));
        await tester.pumpAndSettle();

        expect(find.text('Notification settings saved.'), findsOneWidget);
      },
    );

    testWidgets(
      'PrivacyDataScreen toggles AI consent and reveals inline delete confirmation',
      (tester) async {
        await tester.pumpWidget(wrapScreen(const PrivacyDataScreen()));
        await tester.pumpAndSettle();

        expect(find.text('View your data'), findsOneWidget);
        expect(find.text('Privacy & AI data'), findsOneWidget);
        expect(find.text('Allow meal photo processing'), findsOneWidget);
        expect(find.text('Manage account data'), findsOneWidget);
        expect(find.text('Confirm deletion'), findsNothing);

        await tester.ensureVisible(find.text('Delete account & data'));
        await tester.tap(find.text('Delete account & data'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm deletion'), findsOneWidget);
        expect(
          find.text('I understand this is permanent and irreversible'),
          findsOneWidget,
        );
      },
    );
  });
}
