// import 'dart:html';
import 'dart:async';
import 'dart:math' as math; // ランダム値を取得するライブラリ
import 'package:flutter/services.dart'; // rootBundle
import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/idea_model.dart';
import 'package:flutter_brainstorming/model/database_helper.dart';

// ファイルを読み込んで表示
Future loadAssetsCsvFile(String name) async {
  // ignore: avoid_print
  return rootBundle.loadString('assets/' + name);
}

class InputIdeaPage extends StatelessWidget {
  const InputIdeaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'home',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const BrainPage());
  }
}

class BrainPage extends StatefulWidget {
  const BrainPage({Key? key}) : super(key: key);

  @override
  State<BrainPage> createState() => _BrainPageState();
}

class _BrainPageState extends State<BrainPage> {
  final _ideaLists = [];
  final _textEditingController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  // CSVファイルを読み込み
  final List<String> _data = [];
  String _keyword = '';

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

  // StateクラスのinitStateをオーバーライド
  // 画面描画時に1度のみ実行される
  @override
  void initState() {
    super.initState();
    _loadCSV();
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
                  final ideaModel = IdeaModel.createIdea(value, _keyword);
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
}
