import 'dart:io';

import 'package:siddhartha_cli/utils/app_utils.dart';

class Create {
  static Future<void> cloneProject() async {
    final folderName = await AppUtils.readLine("project");

    if (folderName.trim().isEmpty) {
      print("Folder name is required");
      return;
    }

    final command = await Process.run("git", [
      "clone",
      "https://github.com/dev-siddhartha/Flutter-templete-project.git",
      folderName,
    ]);

    print(command.stdout);
    print(command.stderr);
  }
}
