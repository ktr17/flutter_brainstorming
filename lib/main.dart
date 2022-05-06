// import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: Text("HomePage")),
    //   body: Center(child: Text("child")),
    // );
    return MaterialApp(
        title: 'home',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BrainPage());
  }
}

class BrainPage extends StatefulWidget {
  const BrainPage({Key? key}) : super(key: key);

  @override
  State<BrainPage> createState() => _BrainPageState();
}

class _BrainPageState extends State<BrainPage> {
  final items = [1, 2, 3];
  final ideaLists = [];
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  void _addIdeaList() {
    // setStateの中で値を更新すると、画面が再描画される
    setState(() {
      ideaLists.add(_textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ブレスト")),
        body: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(8.0)),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'キーワードを入力してください。',
                  labelText: 'キーワード',
                ),
                validator: (value) {
                  if (value == null) {
                    return '必須です';
                  }
                  return null;
                },
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
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
                // ボタン押下時に入力した文字列を保存(下のリストに表示)
                print(_textEditingController.text);
                _addIdeaList();
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: ideaLists.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(ideaLists[index]),
                    );
                  }),
            ),
          ],
        ));
  }
}
