abstract final class AuthValidation {
  static bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
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
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'\d').hasMatch(password)) {
      return 'Password needs a letter and a number.';
    }
    if (password != confirmPassword) return 'Passwords must match.';
    if (!termsAccepted) return 'Please accept the terms to continue.';
    return null;
  }
}
