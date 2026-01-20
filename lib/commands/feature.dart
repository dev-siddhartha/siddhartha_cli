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
      final sub = entry.value;

      final folderPath = AppUtils.stringJoin(baseName, folderName);
      final folderDir = Directory(folderPath);

      if (!await folderDir.exists()) {
        folderDir.createSync(recursive: true);
      }

      for (final subFolderName in sub) {
        final subFolderPath = AppUtils.stringJoin(folderPath, subFolderName);
        final subFolderDir = Directory(subFolderPath);

        if (!await subFolderDir.exists()) {
          subFolderDir.createSync(recursive: true);
        }
      }
    }
  }

  Future<void> _createFile(String baseFolder, String featureName) async {
    final baseClassName = AppUtils.upperCamelCase(featureName);
    final repoDir = AppUtils.stringJoin(baseFolder, 'domain', 'repo');
    final implDir = AppUtils.stringJoin(baseFolder, 'data', 'repo_impl');

    final repoFilePath = AppUtils.stringJoin(
      repoDir,
      '${featureName}_repo.dart',
    );
    final implFilePath = AppUtils.stringJoin(
      implDir,
      '${featureName}_repo_impl.dart',
    );

    final repoFile = File(repoFilePath);
    if (!await repoFile.exists()) {
      const repoClassContent = '''
abstract class %sRepo {
  // Define contract methods here
}
''';
      await repoFile.writeAsString(
        repoClassContent.replaceFirst('%s', baseClassName),
      );
      print('Created: $repoFilePath');
    } else {
      print('Skipped (already exists): $repoFilePath');
    }

    final implFile = File(implFilePath);
    if (!await implFile.exists()) {
      final implClassContent =
          '''
import '../../domain/repo/${featureName}_repo.dart';

class ${AppUtils.upperCamelCase(featureName)}RepoImpl extends ${AppUtils.upperCamelCase(featureName)}Repo {
  // Implement methods here
}
''';
      await implFile.writeAsString(implClassContent);
      print('Created: $implFilePath');
    } else {
      print('Skipped (already exists): $implFilePath');
    }

    print("Feature '$featureName' structure is ready inside lib/features.");
  }
}
