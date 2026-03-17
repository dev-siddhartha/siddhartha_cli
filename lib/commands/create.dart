import 'dart:io';
import 'package:siddhartha_cli/utils/app_utils.dart';

class Create {
  static const String _templateAppName = 'flutter_template';
  static const String _templatePackage = 'com.siddhartha.templete';
  static const String _templateDisplayNameDev = 'Flutter Dev';
  static const String _templateDisplayNameProd = 'Flutter Prod';

  static void _removeGitFolder(String projectPath) {
    final gitFolder = Directory('$projectPath/.git');
    if (gitFolder.existsSync()) {
      gitFolder.deleteSync(recursive: true);
    }
  }

  static String _toTitleCase(String input) {
    return input
        .split('_')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  static Future<void> cloneProject() async {
    // Step 1: Ask project name
    final projectName = await AppUtils.readLine(
      "project name (snake_case e.g. my_app)",
    );
    if (projectName.trim().isEmpty) {
      stdout.writeln("Project name is required");
      return;
    }

    // Step 2: Ask package name
    stdout.write("Enter package name (e.g. com.company.myapp): ");
    final packageName = stdin.readLineSync()?.trim() ?? '';
    if (packageName.trim().isEmpty) {
      stdout.writeln("Package name is required");
      return;
    }

    // Step 3: Clone
    stdout.writeln("⏳ Cloning template...");
    final command = await Process.run("git", [
      "clone",
      "https://github.com/dev-siddhartha/Flutter-templete-project.git",
      projectName,
    ]);

    if (command.exitCode != 0) {
      stdout.writeln(command.stderr);
      return;
    }

    // Step 4: Remove .git
    _removeGitFolder(projectName);

    // Step 5: Replace all occurrences inside file contents
    stdout.writeln("⚙️  Configuring project...");
    await _replaceInAllFiles(projectName, projectName, packageName);

    stdout.writeln("✅ Project '$projectName' created successfully!");
    stdout.writeln("👉 Run: cd $projectName && flutter pub get");
  }

  static Future<void> _replaceInAllFiles(
    String dirPath,
    String newAppName,
    String newPackage,
  ) async {
    final dir = Directory(dirPath);
    final displayName = _toTitleCase(newAppName);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        try {
          final content = await entity.readAsString();
          final updated = content
              .replaceAll(_templateAppName, newAppName)
              .replaceAll(_templatePackage, newPackage)
              .replaceAll(_templateDisplayNameDev, '$displayName Dev')
              .replaceAll(_templateDisplayNameProd, displayName);

          if (content != updated) {
            await entity.writeAsString(updated);
          }
        } catch (_) {
          // Skip binary files (images, fonts, compiled files etc.)
        }
      }
    }
  }
}
