class Validators {
  // ---------------- EMAIL ----------------
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your email';

    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';

    // Uncomment to restrict logins to Gmail addresses only:
    // if (!value.trim().toLowerCase().endsWith('@gmail.com')) {
    //   return 'Please use a Gmail address';
    // }

    return null;
  }

  // ---------------- PASSWORD ----------------
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';

    const minLength = 4; // 👈 change this number to adjust minimum length

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    // Requires: 1 uppercase, 1 lowercase, 1 digit, 1 special character
    final strongPassword =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~%^()_+=-]).+$');
    if (!strongPassword.hasMatch(value)) {
      return 'Include an uppercase letter, lowercase letter, number & symbol';
    }

    return null;
  }
}