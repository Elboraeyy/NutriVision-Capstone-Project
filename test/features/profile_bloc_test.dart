import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/features/profile/data/repositories/in_memory_profile_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/user_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_user_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/profile_bloc.dart';

class _FailingProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> getProfile({String? userName, String? userEmail}) {
    throw Exception('Profile unavailable');
  }
}

void main() {
  test(
    'returns default Maya profile when no signed-in user name is given',
    () async {
      final repository = InMemoryProfileRepository();
      final getUserProfile = GetUserProfile(repository);

      final profile = await getUserProfile(userName: '   ');

      expect(profile.name, 'Maya');
      expect(profile.subtitle, 'Your NutriVision profile');
      expect(profile.email, isNull);
    },
  );

  test('returns signed-in user name and email through use case', () async {
    final repository = InMemoryProfileRepository();
    final getUserProfile = GetUserProfile(repository);

    final profile = await getUserProfile(
      userName: '  Nancy  ',
      userEmail: 'nancy@example.com',
    );

    expect(profile.name, 'Nancy');
    expect(profile.subtitle, 'Your NutriVision profile');
    expect(profile.email, 'nancy@example.com');
  });

  test(
    'ProfileBloc emits loading then loaded when ProfileRequested is added',
    () async {
      final bloc = ProfileBloc(GetUserProfile(InMemoryProfileRepository()));
      addTearDown(bloc.close);

      final expectedStates = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProfileState>().having(
            (s) => s.status,
            'status',
            ProfileStatus.loading,
          ),
          isA<ProfileState>()
              .having((s) => s.status, 'status', ProfileStatus.loaded)
              .having((s) => s.profile?.name, 'profile.name', 'Maya'),
        ]),
      );

      bloc.add(const ProfileRequested());
      await expectedStates;
    },
  );

  test('ProfileBloc emits failure when repository throws', () async {
    final bloc = ProfileBloc(GetUserProfile(_FailingProfileRepository()));
    addTearDown(bloc.close);

    final expectedStates = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProfileState>().having(
          (s) => s.status,
          'status',
          ProfileStatus.loading,
        ),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.failure)
            .having(
              (s) => s.message,
              'message',
              contains('Profile unavailable'),
            ),
      ]),
    );

    bloc.add(const ProfileRequested());
    await expectedStates;
  });
}
