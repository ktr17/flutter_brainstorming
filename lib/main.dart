import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/database_helper.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';
import 'brainstorming_page.dart';
import 'package:flutter_brainstorming/add_item_theme_page.dart';
import 'package:flutter_brainstorming/brainstorming_page.dart';

void main() {
  runApp(const IdeaThemePage());
}

/// アイデアテーマを登録・表示するView
class IdeaThemePage extends StatelessWidget {
  const IdeaThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          textTheme: const TextTheme(
              headline5: TextStyle(
                  fontFamily: 'sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white))),
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
  // TODO: _ideaThemeListにはThemeModelを格納するように設計修正する
  // TODO: それにともない、データベースから取り出す処理もThemeModelを返却できるように修正する
  final _ideaThemeList = <String>[];

  /// ListViewに持たせるためのデータをオンメモリ上に配置する
  _getThemeFromDb() {
    final db = DatabaseHelper();
    final themeListFuture = db.getThemeList();
    final themes = <String>[];
    themeListFuture.then((themeList) {
      for (var theme in themeList) {
        themes.add(theme['theme_text']);
        setState(() {
          _ideaThemeList.add(theme['theme_text']);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getThemeFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text('アイデアテーマ', style: Theme.of(context).textTheme.headline5)),
        body: Padding(
          padding: const EdgeInsets.only(right: 40, bottom: 65),
          child: Stack(
            children: [
              // 記入済みのテーマの一覧を表示
              ListView.builder(
                itemCount: _ideaThemeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_ideaThemeList[index]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InputIdeaPage()));
                    },
                  );
                },
              ),
              // TODO: テーマを追加するためのボタンを配置する
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
                    width: 65,
                    height: 65,
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
        ));
  }
}
