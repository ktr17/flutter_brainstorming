import 'package:flutter/material.dart';

import 'package:flutter_brainstorming/model/database_helper.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';
import 'package:flutter_brainstorming/screens/brainstorming_page.dart';
import 'package:flutter_brainstorming/screens/idea_theme_page.dart';
import 'package:flutter_brainstorming/components/list_tile.dart';
/// アイデアのテーマを表示するためのListViewを表示
class ItemThemeListView extends StatefulWidget {
  const ItemThemeListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemThemeListView();
}

class _ItemThemeListView extends State<ItemThemeListView> {
  final _themeModelList = <ThemeModel>[];
  final _ideaThemeList = <String>[];

  /// アプリ起動時にデータベースからテーマの一覧を取得
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
              ListView(                children: buildThemeComponentsList(),
              ),

              // テーマを追加するためのボタンを配置する
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () async {
                    // ideaThemaには遷移先からの返り値が格納される
                    final ThemeModel _themeModel = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ItemThemePage()));
                    setState(() {
                      // リストにテーマを追加して、ListViewを更新する
                      _ideaThemeList.add(_themeModel.getThemeText);
                      // 追加したThemeModelをリストに格納する
                      _themeModelList.add(_themeModel);
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

  /// ThemeListTileComponentの生成
  ///
  /// アイデアのテーマはThemeListTileComponentで作成し、ListViewに表示させる
  List<Widget> buildThemeComponentsList() {
    List<Widget> themeComponentsList = [];

    for (final themeModel in _themeModelList) {
      themeComponentsList.add(ThemeListTileComponent(
          themeData: themeModel, onTapAction: openThemeToRead));
    }

    return themeComponentsList;
  }

  /// テーマを開き、アイデアの追加画面を表示するための関数
  openThemeToRead(ThemeModel themeData) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BrainstormPage(themeModel: themeData)));
  }

  /// ListViewに持たせるためのデータをオンメモリ上に配置する
  _getThemeFromDb() {
    final db = DatabaseHelper();
    final themeListFuture = db.getThemeList();

    // テーマの一覧を取得したら、リストに追加する
    themeListFuture.then((themeList) {
      for (var theme in themeList) {
        _themeModelList.add(ThemeModel(
            themeText: theme['theme_text'], themeId: theme['theme_id']));
        setState(() {
          _ideaThemeList.add(theme['theme_text']);
        });
      }
    });
  }
}
