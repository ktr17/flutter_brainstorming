// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/ui/button_widget.dart';
import 'brainstorming_page.dart';
import 'package:flutter_brainstorming/add_item_theme_page.dart';

void main() {
  runApp(const IdeaThemePage());
}

/// アイデアテーマを登録・表示するView
class IdeaThemePage extends StatelessWidget {
  const IdeaThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: const ItemThemeListView(),
    );
  }
}

/// アイデアのテーマを表示するためのListViewを表示
class ItemThemeListView extends StatefulWidget {
  const ItemThemeListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemThemeListView();
}

class _ItemThemeListView extends State<ItemThemeListView> {
  final _ideaThemeList = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アイデアテーマ')),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _ideaThemeList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_ideaThemeList[index]),
              );
            },
          ),
          // テーマを追加するためのボタンを配置する
          // const Padding(padding: EdgeInsets.all(100)),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () async {
                var ideaThema = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddItemThemePage()));
                setState(() {
                  _ideaThemeList.add(ideaThema);
                  // ListViewに値を追加する
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green,
                ),
                child: const Center(
                    child: Text(
                  '+',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _awaitReturnIdeaTheme(BuildContext context) async {}
}
