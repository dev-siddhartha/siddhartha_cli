import 'dart:io';

import 'package:args/args.dart';
import 'package:siddhartha_cli/utils/app_utils.dart';

const structure = {
  'data': ['repo_impl'],
  'domain': ['repo', 'model'],
  'presentation': ['screens', 'widgets'],
};

class Feature {
  Future<void> init({required ArgResults command}) async {
    final folderName = await AppUtils.readLine("feature");

    if (folderName.trim().isEmpty) {
      print("Folder name is required");
      return;
    }

    final projectRoot = Directory.current.path;

    final baseName = AppUtils.stringJoin(
      projectRoot,
      "lib",
      "features",
      folderName.trim(),
    );
    final parentName = AppUtils.stringJoin(projectRoot, "lib", "features");

    await _createFolder(parentName, baseName);
    _createFile(baseName, folderName);
  }

  Future<void> _createFolder(String parentName, String baseName) async {
    final parentDir = Directory(parentName);
    final baseDir = Directory(baseName);

    if (!await parentDir.exists()) {
      parentDir.createSync(recursive: true);
    }

    if (!await baseDir.exists()) {
      baseDir.createSync(recursive: true);
    }

    for (final entry in structure.entries) {
      final folderName = entry.key;
      final files = entry.value;

      final folderPath = AppUtils.stringJoin(baseName, folderName);
      final folderDir = Directory(folderPath);

      if (!await folderDir.exists()) {
        folderDir.createSync(recursive: true);
      }

      for (final fileName in files) {
        final filePath = AppUtils.stringJoin(folderPath, fileName);
        final file = File(filePath);

        if (!await file.exists()) {
          file.createSync(recursive: true);
        }
      }
    }
  }

  Future<void> _createFile(String baseFolder, String featureName) async {
    final filePath = AppUtils.stringJoin(baseFolder, '$featureName.dart');

    final file = File(filePath);

    if (!await file.exists()) {
      file.createSync(recursive: true);
    }

    final content =
        '''
class ${AppUtils.upperCamelCase(featureName)} {}
''';

    file.writeAsString(content);
  }
}
