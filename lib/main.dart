// import 'dart:html';
import 'dart:async';
import 'dart:math' as math; // ランダム値を取得するライブラリ
import 'package:flutter/services.dart'; // rootBundle
import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage());
}

// ファイルを読み込んで表示
Future loadAssetsCsvFile(String name) async {
  // ignore: avoid_print
  return rootBundle.loadString('assets/' + name);
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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

  // CSVファイルを読み込み
  final List<String> _data = [];
  String _keyword = '';

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString('assets/Noun.csv');

    // 読み込んだCSVを改行コードずつリストへ格納する
    for (String row in _rawData.split('\n')) {
      _data.add(row);
    }

    setState(() {
      _keyword = _data[math.Random().nextInt(_data.length)].split(',').first;
    });
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
              ),
            ),
            ElevatedButton(
              child: const Text('クリック'),
              onPressed: () {
                loadAssetsCsvFile('Noun.csv');
                _loadCSV();
              },
            ),
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
