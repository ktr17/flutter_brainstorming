import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/database_helper.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';

class ItemThemePage extends StatefulWidget {
  const ItemThemePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemThemePage();
}

class _ItemThemePage extends State<ItemThemePage> {
  final _themeTextEditingController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("テーマを入力"), foregroundColor: Colors.white),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 5.0, right: 5.0, bottom: 0),
          child: Column(
            children: <Widget>[
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
                  // 入力したテーマをデータベースへ格納
                  final _themeModel = _dbHelper.newTheme(ThemeModel(themeText: value.toString()));

                  // 戻り値に入力したテーマを格納する
                  Navigator.pop(context, _themeModel);
                },
              ))
            ],
          ),
        ));
  }
}
