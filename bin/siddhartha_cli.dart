import 'dart:io';

import 'package:args/args.dart';
import 'package:siddhartha_cli/commands/create.dart';
import 'package:siddhartha_cli/commands/feature.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  parser.addCommand("create");
  parser.addCommand("feature");

  parser.addFlag("help", abbr: "h", help: "Show help", aliases: ["-h, --help"]);

  final result = parser.parse(arguments);

  if (result.wasParsed("help")) {
    showHelp();
    return;
  }

  if (result.command?.name == "feature") {
    Feature().init(command: result);
  } else if (result.command?.name == "create") {
    Create.cloneProject();
  } else {
    showHelp();
  }
}

void showHelp() {
  stdout.writeln(
    "-------------------------------------------------------------",
  );
  stdout.writeln("Usage: siddhartha_cli <command> [options]");
  stdout.writeln("");
  stdout.writeln("Commands:");
  stdout.writeln("  create <name> - Create a new project");
  stdout.writeln("  feature <name> - Add a new feature in lib/features");
  stdout.writeln("");
  stdout.writeln("Options:");
  stdout.writeln("  -h, --help - Show help");
  stdout.writeln(
    "-------------------------------------------------------------",
  );
}
