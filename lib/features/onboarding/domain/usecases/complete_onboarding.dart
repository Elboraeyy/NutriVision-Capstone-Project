import '../entities/onboarding_profile.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  Future<void> call(OnboardingProfile profile) => _repository.complete(profile);
}
