import 'dart:io';
import 'package:siddhartha_cli/utils/app_utils.dart';

class Create {
  static const String _templateAppName = 'flutter_template';
  static const String _templatePackage = 'com.siddhartha.templete';
  static const String _templateDisplayNameDev = 'Flutter Dev';
  static const String _templateDisplayNameProd = 'Flutter Prod';

  static const String _repoUrl =
      'https://github.com/dev-siddhartha/Flutter-templete-project.git';
  static const String _branchMain = 'main';
  static const String _branchMvvm = 'mvvm-arch';

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
    final projectName = await AppUtils.readLine(
      "project name (snake_case e.g. my_app)",
    );
    if (projectName.trim().isEmpty) {
      stdout.writeln("Project name is required");
      return;
    }

    stdout.write("Enter package name (e.g. com.company.myapp): ");
    final packageName = stdin.readLineSync()?.trim() ?? '';
    if (packageName.trim().isEmpty) {
      stdout.writeln("Package name is required");
      return;
    }

    stdout.writeln("Choose template branch:");
    stdout.writeln("  1) $_branchMain (default)");
    stdout.writeln("  2) $_branchMvvm");
    stdout.write("Enter choice (1 or 2) [1]: ");
    final branchChoice = stdin.readLineSync()?.trim() ?? '';
    final String branch;
    if (branchChoice == '2') {
      branch = _branchMvvm;
    } else {
      if (branchChoice.isNotEmpty && branchChoice != '1') {
        stdout.writeln("Invalid choice; using $_branchMain.");
      }
      branch = _branchMain;
    }

    stdout.writeln(" ====== Cloning project (branch: $branch) ====== ");
    final command = await Process.run("git", [
      "clone",
      "--branch",
      branch,
      _repoUrl,
      projectName,
    ]);

    if (command.exitCode != 0) {
      stdout.writeln(command.stderr);
      return;
    }

    _removeGitFolder(projectName);

    stdout.writeln(" ====== Configuring project ====== ");
    await _replaceInAllFiles(projectName, projectName, packageName);

    stdout.writeln(
      " ====== Project '$projectName' created successfully! ====== ",
    );
    stdout.writeln(" ====== Run: cd $projectName && flutter pub get ====== ");
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
        } catch (_) {}
      }
    }
  }
}
