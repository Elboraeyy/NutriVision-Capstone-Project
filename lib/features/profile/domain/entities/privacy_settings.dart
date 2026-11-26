/// Saved privacy preferences for the user's NutriVision profile.
class PrivacySettings {
  const PrivacySettings({this.allowMealPhotoProcessing = false});

  final bool allowMealPhotoProcessing;

  PrivacySettings copyWith({bool? allowMealPhotoProcessing}) {
    return PrivacySettings(
      allowMealPhotoProcessing:
          allowMealPhotoProcessing ?? this.allowMealPhotoProcessing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrivacySettings &&
        other.allowMealPhotoProcessing == allowMealPhotoProcessing;
  }

  @override
  int get hashCode => allowMealPhotoProcessing.hashCode;
}

/// Thrown when an account data operation requires a backend service that is
/// not yet connected in this build.
class PrivacyBackendUnavailableException implements Exception {
  const PrivacyBackendUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}
