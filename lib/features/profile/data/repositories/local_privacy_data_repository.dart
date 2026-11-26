import '../../domain/entities/privacy_settings.dart';
import '../../domain/repositories/privacy_data_repository.dart';
import '../datasources/privacy_data_local_datasource.dart';
import '../models/privacy_settings_model.dart';

/// Local persistence implementation for privacy preferences.
///
/// Data export and permanent account deletion require a connected backend
/// service and therefore throw [PrivacyBackendUnavailableException] until
/// backend endpoints are integrated.
class LocalPrivacyDataRepository implements PrivacyDataRepository {
  LocalPrivacyDataRepository({PrivacyDataLocalDataSource? localDataSource})
    : _localDataSource =
          localDataSource ?? SharedPrefsPrivacyDataLocalDataSource();

  final PrivacyDataLocalDataSource _localDataSource;

  @override
  Future<PrivacySettings?> getPrivacySettings() async {
    final raw = await _localDataSource.readRawSettings();
    return PrivacySettingsModel.tryDecode(raw);
  }

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    final encoded = PrivacySettingsModel(settings: settings).encode();
    await _localDataSource.writeRawSettings(encoded);
  }

  @override
  Future<void> requestDataExport() async {
    throw const PrivacyBackendUnavailableException(
      'Data export requires a connected backend service and is not available yet.',
    );
  }

  @override
  Future<void> deleteAccount() async {
    throw const PrivacyBackendUnavailableException(
      'Account deletion requires a connected backend service and cannot be completed offline.',
    );
  }
}
