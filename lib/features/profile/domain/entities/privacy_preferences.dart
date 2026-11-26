/// Privacy, AI processing consent, and data management settings.
class PrivacyPreferences {
  const PrivacyPreferences({
    this.allowMealPhotoProcessing = true,
    this.lastExportRequestedAt,
  });

  final bool allowMealPhotoProcessing;
  final DateTime? lastExportRequestedAt;

  PrivacyPreferences copyWith({
    bool? allowMealPhotoProcessing,
    DateTime? lastExportRequestedAt,
    bool clearLastExportRequestedAt = false,
  }) {
    return PrivacyPreferences(
      allowMealPhotoProcessing:
          allowMealPhotoProcessing ?? this.allowMealPhotoProcessing,
      lastExportRequestedAt: clearLastExportRequestedAt
          ? null
          : (lastExportRequestedAt ?? this.lastExportRequestedAt),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrivacyPreferences &&
        other.allowMealPhotoProcessing == allowMealPhotoProcessing &&
        other.lastExportRequestedAt == lastExportRequestedAt;
  }

  @override
  int get hashCode =>
      Object.hash(allowMealPhotoProcessing, lastExportRequestedAt);
}
