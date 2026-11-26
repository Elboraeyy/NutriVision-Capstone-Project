import '../entities/privacy_preferences.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Updates AI photo processing consent and privacy preferences.
class UpdatePrivacyPreferences {
  const UpdatePrivacyPreferences(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call(PrivacyPreferences preferences) {
    return _repository.updatePrivacy(preferences);
  }
}
