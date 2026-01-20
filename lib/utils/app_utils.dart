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

  static String upperCamelCase(String name) {
    final list = name.split("");

    final firstLetter = list[0];

    final upperFirstLetter = firstLetter.toUpperCase();

    return '$upperFirstLetter${list.sublist(1).join("")}';
  }
}
