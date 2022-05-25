import 'dart:async';
import 'dart:io';

import 'package:flutter_brainstorming/model/idea_model.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///アイデアをDBへ格納するためのヘルパークラス
class DatabaseHelper {
  static DatabaseHelper _databaseHelper = DatabaseHelper._createInstance();
  String _dbFilePath = '';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<String> getDbPath() async {
    final dbDirectory = await getLibraryDirectory();
    _dbFilePath = dbDirectory.path;

    // データベースの配置場所を作成し、返却
    final path = join(_dbFilePath, 'sample.db');
    return path;
  }

  // テーブルが存在しない場合は作成する
  void _createTable(final Database db, final String tableName) async {
    await db.execute(
        'CREATE TABLE Theme(theme_id INTEGER PRIMARY KEY AUTOINCREMENT, theme_text TEXT)');
  }

  // TODO: データモデルごとに格納する処理は別クラスに分ける(テーマとアイデア)
  /// データベースを開く(存在しない場合は作成する)処理
  Future<Database> getDatabase() async {
    final path = await getDbPath();
    final db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Idea(idea_id INTEGER PRIMARY KEY AUTOINCREMENT, random_keyword TEXT, idea_text TEXT, theme_id INTEGER)');
      await db.execute(
          'CREATE TABLE Theme(theme_id INTEGER PRIMARY KEY AUTOINCREMENT, theme_text TEXT)');
    });
    return db;
  }

  /// 新規のアイデアをテーブルへ追加
  newIdea(IdeaModel newIdea) async {
    final db = await getDatabase();
    final raw = await db.rawInsert(
        'INSERT Into Idea(random_keyword, idea_text, theme_id) VALUES ("${newIdea.randomKeyword}", "${newIdea.ideaText}", "${newIdea.themeId}")');
    return raw;
  }

  /// 新規のテーマをテーブルへ追加
  newTheme(ThemeModel themeModel) async {
    final db = await getDatabase();
    final raw = await db.rawInsert(
        'INSERT Into Theme(theme_text) VALUES ("${themeModel.themeText}")');

    return raw;
  }

  /// テーマの一覧を取得
  Future<List<Map<String, dynamic>>> getThemeList() async {
    final db = await getDatabase();
    // SELECT * FROM SELECT theme_text from Theme'
    final result = db.query('Theme', columns: ['theme_text']);

    return result;
  }
}
