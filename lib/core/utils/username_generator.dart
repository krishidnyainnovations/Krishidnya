import 'dart:math';

/// Generates unique usernames from full names.
/// Example: "Tejas Barguje" → "tejas_barguje"
abstract final class UsernameGenerator {
  static String fromFullName(String fullName) {
    final normalized = fullName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_');

    return normalized.isEmpty ? 'farmer' : normalized;
  }

  /// Generates alternative username if the base is taken.
  static String withSuffix(String baseUsername, {int? attempt}) {
    final suffix = attempt ?? Random().nextInt(9999);
    return '${baseUsername}_$suffix';
  }

  /// Attempts to create a unique username with incremental suffixes.
  static Future<String> generateUnique({
    required String fullName,
    required Future<bool> Function(String username) isAvailable,
    int maxAttempts = 5,
  }) async {
    final base = fromFullName(fullName);
    var username = base;

    for (var i = 0; i < maxAttempts; i++) {
      final available = await isAvailable(username);
      if (available) return username;
      username = withSuffix(base, attempt: i + 1);
    }

    return withSuffix(base);
  }
}
