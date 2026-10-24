abstract final class AuthValidation {
  static bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }

  static bool hasMinimumPasswordLength(String value) => value.length >= 8;

  static bool hasPasswordLetter(String value) =>
      RegExp(r'[A-Za-z]').hasMatch(value);

  static bool hasPasswordNumber(String value) => RegExp(r'\d').hasMatch(value);

  static bool isValidPassword(String value) {
    return hasMinimumPasswordLength(value) &&
        hasPasswordLetter(value) &&
        hasPasswordNumber(value);
  }

  static String? validateSignIn({
    required String email,
    required String password,
  }) {
    if (!isValidEmail(email)) return 'Please enter a valid email.';
    if (password.trim().isEmpty) return 'Please enter your password.';
    return null;
  }

  static String? validateSignUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  }) {
    if (name.trim().isEmpty) return 'Please enter your name.';
    if (!isValidEmail(email)) return 'Please enter a valid email.';
    if (!hasMinimumPasswordLength(password)) {
      return 'Password must be at least 8 characters.';
    }
    if (!hasPasswordLetter(password) || !hasPasswordNumber(password)) {
      return 'Password needs a letter and a number.';
    }
    if (password != confirmPassword) return 'Passwords must match.';
    if (!termsAccepted) return 'Please accept the terms to continue.';
    return null;
  }
}
