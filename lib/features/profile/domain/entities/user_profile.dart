import 'daily_nutrition_targets.dart';
import 'notification_preferences.dart';
import 'privacy_preferences.dart';

/// Complete profile & settings entity for the signed-in user.
class UserProfile {
  const UserProfile({
    this.displayName = 'Maya',
    this.subtitle = 'Your NutriVision profile',
    this.goal = 'Eat Healthier',
    this.dietaryPattern = 'Flexitarian',
    this.allergies = const {'Peanuts'},
    this.noAllergies = false,
    this.excludedIngredients = const {'Alcohol'},
    this.favoriteFoods = const {'Oats', 'Berries', 'Salmon'},
    this.dailyTargets = const DailyNutritionTargets(),
    this.notifications = const NotificationPreferences(),
    this.privacy = const PrivacyPreferences(),
  });

  final String displayName;
  final String subtitle;
  final String goal;
  final String dietaryPattern;
  final Set<String> allergies;
  final bool noAllergies;
  final Set<String> excludedIngredients;
  final Set<String> favoriteFoods;
  final DailyNutritionTargets dailyTargets;
  final NotificationPreferences notifications;
  final PrivacyPreferences privacy;

  UserProfile copyWith({
    String? displayName,
    String? subtitle,
    String? goal,
    String? dietaryPattern,
    Set<String>? allergies,
    bool? noAllergies,
    Set<String>? excludedIngredients,
    Set<String>? favoriteFoods,
    DailyNutritionTargets? dailyTargets,
    NotificationPreferences? notifications,
    PrivacyPreferences? privacy,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      subtitle: subtitle ?? this.subtitle,
      goal: goal ?? this.goal,
      dietaryPattern: dietaryPattern ?? this.dietaryPattern,
      allergies: allergies ?? this.allergies,
      noAllergies: noAllergies ?? this.noAllergies,
      excludedIngredients: excludedIngredients ?? this.excludedIngredients,
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
      dailyTargets: dailyTargets ?? this.dailyTargets,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.displayName == displayName &&
        other.subtitle == subtitle &&
        other.goal == goal &&
        other.dietaryPattern == dietaryPattern &&
        _setEquals(other.allergies, allergies) &&
        other.noAllergies == noAllergies &&
        _setEquals(other.excludedIngredients, excludedIngredients) &&
        _setEquals(other.favoriteFoods, favoriteFoods) &&
        other.dailyTargets == dailyTargets &&
        other.notifications == notifications &&
        other.privacy == privacy;
  }

  @override
  int get hashCode => Object.hash(
    displayName,
    subtitle,
    goal,
    dietaryPattern,
    Object.hashAllUnordered(allergies),
    noAllergies,
    Object.hashAllUnordered(excludedIngredients),
    Object.hashAllUnordered(favoriteFoods),
    dailyTargets,
    notifications,
    privacy,
  );
}

bool _setEquals(Set<String> a, Set<String> b) {
  if (a.length != b.length) return false;
  return a.containsAll(b);
}
