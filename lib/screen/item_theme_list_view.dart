import 'package:flutter/material.dart';

import 'package:flutter_brainstorming/model/database_helper.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';
import 'package:flutter_brainstorming/screen/brainstorming_page.dart';
import 'package:flutter_brainstorming/screen/input_theme_dialog.dart';
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
            title: Text('テーマ', style: Theme.of(context).textTheme.headline5)),
        body: Padding(
          padding: const EdgeInsets.only(right: 0, bottom: 65),
          child: Stack(
            children: [
              // 記入済みのテーマの一覧を表示
              ListView.separated(
                itemCount: _themeModelList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey<String>(_themeModelList[index].getThemeText),
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsets.only(right: 10),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        // ListViewからデータを削除する処理
                        setState(() {
                          // データベースから削除
                          removeThemeFromDb(_themeModelList[index]);
                          // オンメモリから削除
                          _themeModelList.removeAt(index);
                        });
                      }
                    },
                    child: ListTile(
                        title: Text(_themeModelList[index].getThemeText),
                        onTap: () => openThemeToRead(_themeModelList[index])),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0.5);
                },
              ),

              // テーマを追加するためのボタンを配置する
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      child: const Icon(Icons.add, color: Colors.white),
                      // addボタンをタップしたらテーマを入力するダイアログを表示する
                      onPressed: () async {
                        final ThemeModel _themeModel = await showDialog(
                          context: context,
                          builder: (_) {
                            return InputThemeDialog();
                          },
                        );
                        setState(() {
                          // リストにテーマを追加して、ListViewを更新する
                          _ideaThemeList.add(_themeModel.getThemeText);
                          // 追加したThemeModelをリストに格納する
                          _themeModelList.add(_themeModel);
                        });
                      })),
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
        MaterialPageRoute(
            builder: (context) => BrainstormPage(themeModel: themeData)));
  }

  // ListViewから削除したテーマをDBから削除する
  removeThemeFromDb(ThemeModel themeData) {
    final db = DatabaseHelper();
    db.removeTheme(themeData);
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
