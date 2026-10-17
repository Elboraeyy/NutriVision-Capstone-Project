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
}
