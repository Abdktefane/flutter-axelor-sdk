import 'dart:convert';
import 'dart:io';

class FixtureReader {
  static String read(String name) => File(FixtureReader.fixPath(name)).readAsStringSync();

  static Map<String, dynamic> readJson(String name) =>
      json.decode(File(FixtureReader.fixPath(name)).readAsStringSync()) as Map<String, dynamic>;

  static const String path = 'test/fixtures';

  static String fixPath(String path) => FixtureReader.path + path + '.json';
}
