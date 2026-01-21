import 'dart:io';

import 'package:siddhartha_cli/utils/app_utils.dart';

class Create {
  static void _removeGitFolder(String projectPath) {
    final gitFolder = Directory(AppUtils.stringJoin(projectPath, ".git"));

    if (gitFolder.existsSync()) {
      gitFolder.deleteSync(recursive: true);
    }
  }

  static Future<void> cloneProject() async {
    final folderName = await AppUtils.readLine("project");

    if (folderName.trim().isEmpty) {
      stdout.writeln("Folder name is required");
      return;
    }

    final command = await Process.run("git", [
      "clone",
      "https://github.com/dev-siddhartha/Flutter-templete-project.git",
      folderName,
    ]);

    if (command.exitCode == 0) {
      _removeGitFolder(folderName);
    } else {
      stdout.writeln(command.stderr);
    }
  }
}
