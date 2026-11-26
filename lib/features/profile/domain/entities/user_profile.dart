/// Immutable profile summary displayed on the Profile & Settings screen.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.subtitle,
    this.email,
    this.avatarAsset,
  });

  final String name;
  final String subtitle;
  final String? email;
  final String? avatarAsset;

  UserProfile copyWith({
    String? name,
    String? subtitle,
    String? email,
    String? avatarAsset,
  }) {
    return UserProfile(
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      email: email ?? this.email,
      avatarAsset: avatarAsset ?? this.avatarAsset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.name == name &&
        other.subtitle == subtitle &&
        other.email == email &&
        other.avatarAsset == avatarAsset;
  }

  @override
  int get hashCode => Object.hash(name, subtitle, email, avatarAsset);
}
