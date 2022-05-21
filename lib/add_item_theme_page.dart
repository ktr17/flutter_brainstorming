import 'package:flutter/material.dart';

class AddItemThemePage extends StatefulWidget {
  const AddItemThemePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddItemThemePage();
}

class _AddItemThemePage extends State<AddItemThemePage> {
  final _themeTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("テーマを入力"), foregroundColor: Colors.white),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: 5.0, right: 5.0, bottom: 0),
          child: Column(
            children: <Widget>[
              // const Padding(padding: EdgeInsets.fromLTRB(0, 10.0, 10.0, 0)),
              Form(
                  child: TextFormField(
                controller: _themeTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'テーマ...',
                  labelText: 'アイデアのテーマ',
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                // エンター押下時に入力したテーマをListViewへ追加し、画面を１つ戻す
                onFieldSubmitted: (String? value) {
                  Navigator.pop(context, value);
                },
              ))
            ],
          ),
        ));
  }
}
