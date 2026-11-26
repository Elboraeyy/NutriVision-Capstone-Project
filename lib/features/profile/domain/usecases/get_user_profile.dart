import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Loads the user's profile summary for the profile feature.
class GetUserProfile {
  const GetUserProfile(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call({String? userName, String? userEmail}) {
    return _repository.getProfile(userName: userName, userEmail: userEmail);
  }
}
