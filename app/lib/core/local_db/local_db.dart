// UNVERIFIED DRAFT — not run/tested against a real Flutter build.
// Copies bundled offline_package sqlite files (knowledge.sqlite,
// hazard_grid.sqlite) from assets to app storage on first launch,
// then opens them for querying.


import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocalDb {
  static Database? _knowledgeDb;
  static Database? _hazardDb;

  static Future<Database> get knowledgeDb async {
    _knowledgeDb ??= await _openOrCopy('knowledge.sqlite');
    return _knowledgeDb!;
  }

  static Future<Database> get hazardDb async {
    _hazardDb ??= await _openOrCopy('hazard_grid.sqlite');
    return _hazardDb!;
  }

  static Future<Database> _openOrCopy(String fileName) async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = join(dbDir.path, fileName);

    if (!await File(dbPath).exists()) {
      // Copy from bundled asset (built by pipeline/package_builder or
      // pipeline/gis on the laptop, placed in app/assets/offline_package/)
      final data = await rootBundle.load('assets/offline_package/$fileName');
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(dbPath, readOnly: true);
  }

  /// Returns the package_meta / grid_meta key-value pairs so the UI can
  /// show version/timestamp/staleness info per the provenance requirement.
  static Future<Map<String, String>> getPackageMeta() async {
    final db = await knowledgeDb;
    final rows = await db.query('package_meta');
    return {for (var r in rows) r['key'] as String: r['value'] as String};
  }
}
