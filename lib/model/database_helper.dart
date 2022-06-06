import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/idea_model.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

///アイデアをDBへ格納するためのヘルパークラス
class DatabaseHelper {
  static final DatabaseHelper _databaseHelper =
      DatabaseHelper._createInstance();
  String _dbFilePath = '';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<String> getDbPath() async {
    final dbDirectory = await getLibraryDirectory();
    _dbFilePath = dbDirectory.path;

    // データベースの配置場所を作成し、返却
    final path = join(_dbFilePath, 'brainstorming.db');
    return path;
  }

  /// データベースを開く(存在しない場合は作成する)処理
  Future<Database> getDatabase() async {
    final path = await getDbPath();
    final db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Idea(idea_id INTEGER PRIMARY KEY AUTOINCREMENT, random_keyword TEXT, idea_text TEXT, theme_id TEXT)');
      await db.execute(
          'CREATE TABLE Theme(theme_id TEXT PRIMARY KEY, theme_text TEXT)');
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

  /// データ削除
  removeTheme(ThemeModel themeModel) async {
    final db = await getDatabase();
    final raw = await db.delete("Theme",
        where: "theme_id=?", whereArgs: [themeModel.getThemeId]);
    return raw;
  }

  /// 新規のテーマをテーブルへ追加
  Future<ThemeModel> newTheme(ThemeModel themeModel) async {
    final db = await getDatabase();
    final uuid = const Uuid().v1();
    final raw = await db.rawInsert(
        'INSERT Into Theme(theme_id, theme_text) VALUES ("$uuid", "${themeModel.getThemeText}")');

    final _themeModel =
        ThemeModel(themeText: themeModel.getThemeText, themeId: uuid);

    return _themeModel;
  }

  /// テーマの一覧を取得
  Future<List<Map<String, dynamic>>> getThemeList() async {
    final db = await getDatabase();
    // SELECT * FROM SELECT theme_text from Theme'
    final result = db.query('Theme', columns: ['theme_text', 'theme_id']);

    return result;
  }

  /// テーマIDの一覧を取得
  Future<List<Map<String, dynamic>>> getThemeIdList() async {
    final db = await getDatabase();
    final result = db.query('Theme', columns: ['theme_id']);

    return result;
  }

  /// テーマIDに紐づくアイデアを取得
  Future<List<Map<String, dynamic>>> getIdeaListFromDbByThemeId(
      {required String themeId}) async {
    final db = await getDatabase();
    final result = db.query('Idea', where: 'theme_id = "$themeId"');

    return result;
  }
}
