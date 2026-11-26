import '../entities/notification_preferences.dart';
import '../entities/privacy_preferences.dart';
import '../entities/user_profile.dart';

/// Contract for loading and updating user profile & settings.
abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateGoalsAndPreferences(UserProfile profile);

  Future<UserProfile> updateNotifications(
    NotificationPreferences notifications,
  );

  Future<UserProfile> updatePrivacy(PrivacyPreferences privacy);

  Future<void> requestDataExport();

  Future<void> deleteAccountData();
}
