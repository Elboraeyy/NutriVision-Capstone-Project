import 'dart:convert';

import '../../domain/entities/privacy_settings.dart';

/// JSON serialization model for [PrivacySettings].
class PrivacySettingsModel {
  const PrivacySettingsModel({required this.settings});

  final PrivacySettings settings;

  Map<String, dynamic> toJson() {
    return {'allowMealPhotoProcessing': settings.allowMealPhotoProcessing};
  }

  String encode() => jsonEncode(toJson());

  static PrivacySettings? tryDecode(String? rawJson) {
    if (rawJson == null || rawJson.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) return null;
      final allow = decoded['allowMealPhotoProcessing'];
      return PrivacySettings(
        allowMealPhotoProcessing: allow is bool ? allow : false,
      );
    } catch (_) {
      return null;
    }
  }
}
