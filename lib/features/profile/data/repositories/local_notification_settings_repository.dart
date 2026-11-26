import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_settings_repository.dart';
import '../datasources/notification_permission_datasource.dart';
import '../datasources/notification_settings_local_datasource.dart';
import '../models/notification_settings_model.dart';

/// Coordinates local notification settings storage and OS permission status.
class LocalNotificationSettingsRepository
    implements NotificationSettingsRepository {
  LocalNotificationSettingsRepository({
    NotificationSettingsLocalDataSource? localDataSource,
    NotificationPermissionDataSource? permissionDataSource,
  }) : _localDataSource =
           localDataSource ?? SharedPrefsNotificationSettingsLocalDataSource(),
       _permissionDataSource =
           permissionDataSource ?? DeviceNotificationPermissionDataSource();

  final NotificationSettingsLocalDataSource _localDataSource;
  final NotificationPermissionDataSource _permissionDataSource;

  @override
  Future<NotificationSettings?> loadSettings() async {
    final raw = await _localDataSource.readRawSettings();
    if (raw == null || raw.trim().isEmpty) return null;
    final model = NotificationSettingsModel.tryDecode(raw);
    return model?.toEntity();
  }

  @override
  Future<void> saveSettings(NotificationSettings settings) async {
    final model = NotificationSettingsModel.fromEntity(settings);
    await _localDataSource.writeRawSettings(model.encode());
  }

  @override
  Future<NotificationPermissionStatus> checkPermissionStatus() {
    return _permissionDataSource.checkStatus();
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() {
    return _permissionDataSource.requestPermission();
  }

  @override
  Future<bool> openAppNotificationSettings() {
    return _permissionDataSource.openSystemSettings();
  }
}
