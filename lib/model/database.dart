import 'dart:async';
import 'dart:io';

import 'package:flutter_brainstorming/model/idea_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  String dbFilePath = '';

  Future<String> getDbPath() async {
    final dbDirectory = await getLibraryDirectory();
    dbFilePath = dbDirectory.path;

    // データベースの配置場所を作成し、返却
    final path = join(dbFilePath, 'sample.db');
    return path;
  }

  /// データベースを開く(存在しない場合は作成する)処理
  Future<Database> getDatabase() async {
    final path = await getDbPath();
    final db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Idea(id INTEGER PRIMARY KEY AUTOINCREMENT, random_keyword TEXT, idea_theme TEXT, idea TEXT)');
    });

    return db;
  }

  /// 新規のアイデアをデータベースへ追加
  newIdea(IdeaModel newIdea) async {
    final db = await getDatabase();
    // await db.rawInsert('INSERT INTO dogs(id, name, age) VALUES (${dog.id}, "${dog.name}", ${dog.age})');

    var raw = await db.rawInsert('INSERT Into Idea(random_keyword, idea_theme, idea) VALUES ("${newIdea.randomKeyword}", "${newIdea.ideaTheme}", "${newIdea.idea}")');

    return raw;
  }
}
