import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/notification_settings.dart';

/// Abstraction over OS notification permissions and app settings navigation.
abstract class NotificationPermissionDataSource {
  Future<NotificationPermissionStatus> checkStatus();

  Future<NotificationPermissionStatus> requestPermission();

  Future<bool> openSystemSettings();
}

/// Uses `permission_handler` to query and request notification permission.
class DeviceNotificationPermissionDataSource
    implements NotificationPermissionDataSource {
  @override
  Future<NotificationPermissionStatus> checkStatus() async {
    try {
      final status = await Permission.notification.status;
      return _mapStatus(status);
    } catch (_) {
      return NotificationPermissionStatus.notChecked;
    }
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    try {
      final status = await Permission.notification.request();
      return _mapStatus(status);
    } catch (_) {
      return NotificationPermissionStatus.notChecked;
    }
  }

  @override
  Future<bool> openSystemSettings() async {
    try {
      return await openAppSettings();
    } catch (_) {
      return false;
    }
  }

  NotificationPermissionStatus _mapStatus(PermissionStatus status) {
    if (status.isGranted || status.isProvisional) {
      return NotificationPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return NotificationPermissionStatus.permanentlyDenied;
    }
    if (status.isDenied) {
      return NotificationPermissionStatus.denied;
    }
    return NotificationPermissionStatus.notChecked;
  }
}
