import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/database_helper.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';

/// テーマを入力するモーダルダイアログ
class InputThemeDialog extends StatelessWidget {
  InputThemeDialog({Key? key}) : super(key: key);

  final _themeTextEditingController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('テーマを入力'),
      // content: Text('こうかいしませんね？'),
      actions: <Widget>[
        Form(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value!.isEmpty){
                return 'テーマを入力してください';
              } else {
                return null;
              }
            },
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
              // TODO dbHelperの動作をrepositoryに移行するべき(データベースとのやり取りのため)
              final _themeModel =
                  _dbHelper.newTheme(ThemeModel(themeText: value.toString()));

              // 戻り値に入力したテーマを格納する
              Navigator.pop(context, _themeModel);
            },
          )
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('追加'),
        ),

        // GestureDetector(

        //   child: const Text('Add'),
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}
