import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Loads the user's current profile and settings.
class GetUserProfile {
  const GetUserProfile(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call() => _repository.getProfile();
}
