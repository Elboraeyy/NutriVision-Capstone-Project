import '../../domain/entities/onboarding_profile.dart';
import '../../domain/repositories/onboarding_repository.dart';

/// Temporary repository used until local persistence/Firebase is connected.
class InMemoryOnboardingRepository implements OnboardingRepository {
  OnboardingProfile _profile = const OnboardingProfile();

  @override
  OnboardingProfile get draft => _profile;

  @override
  Future<void> saveDraft(OnboardingProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> complete(OnboardingProfile profile) async {
    _profile = profile;
  }
}
