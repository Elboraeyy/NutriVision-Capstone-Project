import '../entities/privacy_settings.dart';
import '../repositories/privacy_data_repository.dart';

/// Loads saved privacy preferences.
class GetPrivacySettings {
  const GetPrivacySettings(this._repository);

  final PrivacyDataRepository _repository;

  Future<PrivacySettings?> call() => _repository.getPrivacySettings();
}

/// Persists updated privacy preferences.
class SavePrivacySettings {
  const SavePrivacySettings(this._repository);

  final PrivacyDataRepository _repository;

  Future<void> call(PrivacySettings settings) =>
      _repository.savePrivacySettings(settings);
}

/// Requests a copy of the user's account and diary data.
class RequestAccountDataExport {
  const RequestAccountDataExport(this._repository);

  final PrivacyDataRepository _repository;

  Future<void> call() => _repository.requestDataExport();
}

/// Permanently deletes the user's account and diary history.
class DeleteUserAccount {
  const DeleteUserAccount(this._repository);

  final PrivacyDataRepository _repository;

  Future<void> call() => _repository.deleteAccount();
}
