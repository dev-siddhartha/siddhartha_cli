import 'dart:io';

class AppUtils {
  static Future<String> readLine(String type) async {
    stdout.write("Enter $type name: ");
    return stdin.readLineSync() ?? "";
  }

  static String stringJoin(
    String parent, [
    String? p1,
    String? p2,
    String? p3,
    String? p4,
  ]) {
    final parts = [
      parent,
      if (p1 != null) p1,
      if (p2 != null) p2,
      if (p3 != null) p3,
      if (p4 != null) p4,
    ];
    return parts.join(Platform.pathSeparator);
  }

  /// PascalCase from snake_case or kebab-case (e.g. `new_feature` → `NewFeature`).
  static String upperCamelCase(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;

    return trimmed
        .split(RegExp(r'[_\s-]+'))
        .where((segment) => segment.isNotEmpty)
        .map((segment) {
          final lower = segment.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join('');
  }
}
