import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Temporary in-memory profile source used until a remote backend is connected.
class InMemoryProfileRepository implements ProfileRepository {
  static const _defaultName = 'Maya';
  static const _defaultSubtitle = 'Your NutriVision profile';

  @override
  Future<UserProfile> getProfile({String? userName, String? userEmail}) async {
    final trimmedName = userName?.trim();
    final trimmedEmail = userEmail?.trim();

    return UserProfile(
      name: trimmedName != null && trimmedName.isNotEmpty
          ? trimmedName
          : _defaultName,
      subtitle: _defaultSubtitle,
      email: trimmedEmail != null && trimmedEmail.isNotEmpty
          ? trimmedEmail
          : null,
    );
  }
}
