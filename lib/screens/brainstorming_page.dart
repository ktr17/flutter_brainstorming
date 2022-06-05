// import 'dart:html';
import 'dart:async';
import 'dart:math' as math; // ランダム値を取得するライブラリ
import 'package:flutter/services.dart'; // rootBundle
import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/idea_model.dart';
import 'package:flutter_brainstorming/model/database_helper.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';

class BrainstormPage extends StatefulWidget {
  final ThemeModel themeModel;
  const BrainstormPage({Key? key, required this.themeModel}) : super(key: key);

  @override
  State<BrainstormPage> createState() => _BrainstormPageState();
}

class _BrainstormPageState extends State<BrainstormPage> {
  final _ideaLists = [];
  final _textEditingController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();


  // CSVファイルを読み込み
  final List<String> _data = [];
  String _keyword = '';

  // StateクラスのinitStateをオーバーライド
  // 画面描画時に1度のみ実行される
  @override
  void initState() {
    super.initState();
    _loadCSV();
    _getIdeaFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ブレスト")),
        body: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(8.0)),
            ListTile(title: Text(_keyword)),
            const Padding(padding: EdgeInsets.all(8.0)),
            Form(
              child: TextFormField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'アイデア',
                  labelText: 'アイデア',
                ),
                // Enterキー押下でアイデアをリストに追加
                onFieldSubmitted: (String? value) {
                  if (value == null) return;
                  // データベースにアイデアを保存
                  final ideaModel = IdeaModel.createIdea(value, _keyword, widget.themeModel.getThemeId);
                  dbHelper.newIdea(ideaModel);
                  setState(() {
                    // アイデアをListViewに追加
                    _ideaLists.add(value);
                    _keyword = _data[math.Random().nextInt(_data.length)]
                        .split(',')
                        .first;
                    _textEditingController.text = '';
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  // キーワードを更新
                  setState(() {
                    _keyword = _data[math.Random().nextInt(_data.length)]
                        .split(',')
                        .first;
                  });
                },
                child: const Text('キーワード更新')),
            Expanded(
              child: ListView.builder(
                  itemCount: _ideaLists.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_ideaLists[index]),
                    );
                  }),
            ),
          ],
        ));
  }

  /// assets/内のNoun.csvを読み出し、配列上に展開する
  /// [in]: void
  /// [out]: _keyword 名詞のリスト
  void _loadCSV() async {
    Future<String> _rawData = rootBundle.loadString('assets/Noun.csv');
    _rawData.then((value) {
      // 読み込んだCSVを改行コードずつリストへ格納する
      for (String row in value.split('\n')) {
        _data.add(row);
      }
      setState(() {
        _keyword = getRandomNoun();
      });
    });
  }

  /// CSVファイルから抽出した名詞データをランダムで1つ返す
  String getRandomNoun() =>
      _data[math.Random().nextInt(_data.length)].split(',').first;

  /// 受け取ったテーマのIDに関連するアイデアの一覧をデータベースから取得する
  void _getIdeaFromDb() async {
    final ideaData = dbHelper.getIdeaListFromDbByThemeId(
        themeId: widget.themeModel.getThemeId);

    // 取得したデータを1つずつ_ideaListsに格納する
    ideaData.then((ideas) {
      for (final idea in ideas) {
        _ideaLists.add(idea['idea_text']);
      }
    });
  }
}

// ファイルを読み込んで表示
Future loadAssetsCsvFile(String name) async {
  return rootBundle.loadString('assets/' + name);
}
