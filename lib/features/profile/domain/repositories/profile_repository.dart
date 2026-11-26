import '../entities/user_profile.dart';

/// Contract for loading user profile information.
abstract class ProfileRepository {
  Future<UserProfile> getProfile({String? userName, String? userEmail});
}
