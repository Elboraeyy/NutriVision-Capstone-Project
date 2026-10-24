class OnboardingProfile {
  const OnboardingProfile({
    this.goal,
    this.dietaryPreferences = const {},
    this.favoriteFoods = const {},
    this.allergies = const {},
    this.noAllergies = false,
  });

  final String? goal;
  final Set<String> dietaryPreferences;
  final Set<String> favoriteFoods;
  final Set<String> allergies;
  final bool noAllergies;

  OnboardingProfile copyWith({
    String? goal,
    Set<String>? dietaryPreferences,
    Set<String>? favoriteFoods,
    Set<String>? allergies,
    bool? noAllergies,
  }) {
    return OnboardingProfile(
      goal: goal ?? this.goal,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
      allergies: allergies ?? this.allergies,
      noAllergies: noAllergies ?? this.noAllergies,
    );
  }
}
