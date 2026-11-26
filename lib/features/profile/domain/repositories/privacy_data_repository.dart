import '../entities/privacy_settings.dart';

/// Contract for loading/saving privacy preferences and handling account data
/// requests.
abstract interface class PrivacyDataRepository {
  /// Returns saved privacy preferences, or `null` when none are stored yet.
  Future<PrivacySettings?> getPrivacySettings();

  /// Persists [settings] locally.
  Future<void> savePrivacySettings(PrivacySettings settings);

  /// Requests an export of account and diary data from the backend service.
  ///
  /// Throws [PrivacyBackendUnavailableException] when no export service is
  /// connected.
  Future<void> requestDataExport();

  /// Permanently deletes the user's account and diary history via the backend
  /// authentication/account service.
  ///
  /// Throws [PrivacyBackendUnavailableException] when no account deletion
  /// service is connected.
  Future<void> deleteAccount();
}
