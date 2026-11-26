import '../../../onboarding/domain/entities/onboarding_profile.dart';
import '../../../onboarding/domain/repositories/onboarding_repository.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/privacy_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Backend-independent in-memory profile repository.
///
/// Optionally synchronizes shared onboarding preferences with
/// [OnboardingRepository] so goal, dietary pattern, favorite foods, and
/// allergies stay on a single source of truth.
class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository({OnboardingRepository? onboardingRepository})
    : _onboardingRepository = onboardingRepository;

  final OnboardingRepository? _onboardingRepository;
  UserProfile _profile = const UserProfile();

  @override
  Future<UserProfile> getProfile() async {
    final draft = _onboardingRepository?.draft;
    if (draft != null) {
      _profile = _mergeWithOnboarding(_profile, draft);
    }
    return _profile;
  }

  @override
  Future<UserProfile> updateGoalsAndPreferences(UserProfile profile) async {
    _profile = profile;
    if (_onboardingRepository != null) {
      final dietarySet = profile.dietaryPattern.trim().isEmpty
          ? <String>{}
          : <String>{profile.dietaryPattern};
      await _onboardingRepository.saveDraft(
        OnboardingProfile(
          goal: profile.goal,
          dietaryPreferences: dietarySet,
          favoriteFoods: {...profile.favoriteFoods},
          allergies: profile.noAllergies ? const {} : {...profile.allergies},
          noAllergies: profile.noAllergies,
        ),
      );
    }
    return _profile;
  }

  @override
  Future<UserProfile> updateNotifications(
    NotificationPreferences notifications,
  ) async {
    _profile = _profile.copyWith(notifications: notifications);
    return _profile;
  }

  @override
  Future<UserProfile> updatePrivacy(PrivacyPreferences privacy) async {
    _profile = _profile.copyWith(privacy: privacy);
    return _profile;
  }

  @override
  Future<void> requestDataExport() async {
    _profile = _profile.copyWith(
      privacy: _profile.privacy.copyWith(lastExportRequestedAt: DateTime.now()),
    );
  }

  @override
  Future<void> deleteAccountData() async {
    _profile = const UserProfile();
    if (_onboardingRepository != null) {
      await _onboardingRepository.saveDraft(const OnboardingProfile());
    }
  }

  UserProfile _mergeWithOnboarding(
    UserProfile base,
    OnboardingProfile onboarding,
  ) {
    final hasDietary = onboarding.dietaryPreferences.isNotEmpty;
    final hasFavorites = onboarding.favoriteFoods.isNotEmpty;
    final hasAllergies =
        onboarding.noAllergies || onboarding.allergies.isNotEmpty;

    return base.copyWith(
      goal: onboarding.goal?.trim().isNotEmpty == true
          ? onboarding.goal!
          : base.goal,
      dietaryPattern: hasDietary
          ? onboarding.dietaryPreferences.first
          : base.dietaryPattern,
      favoriteFoods: hasFavorites
          ? {...onboarding.favoriteFoods}
          : base.favoriteFoods,
      allergies: hasAllergies
          ? (onboarding.noAllergies
                ? const <String>{}
                : {...onboarding.allergies})
          : base.allergies,
      noAllergies: hasAllergies ? onboarding.noAllergies : base.noAllergies,
    );
  }
}
