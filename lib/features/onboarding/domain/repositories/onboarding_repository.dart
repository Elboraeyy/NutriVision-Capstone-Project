import '../entities/onboarding_profile.dart';

abstract interface class OnboardingRepository {
  OnboardingProfile get draft;

  Future<void> saveDraft(OnboardingProfile profile);

  Future<void> complete(OnboardingProfile profile);
}
