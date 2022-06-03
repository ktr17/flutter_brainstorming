import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/model/theme_model.dart';

/// テーマのWidgetを生成する
///
/// [themeData]にはThemeModelを渡す
/// [onTapAction]にはListView上でタップしたときの動作を渡す

class ThemeListTileComponent extends StatelessWidget {
  final ThemeModel themeData;
  final Function(ThemeModel themeData) onTapAction;

  const ThemeListTileComponent(
      {required this.themeData, required this.onTapAction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(themeData.getThemeText),
      onTap: () {
        onTapAction(themeData);
      },
    );
  }
}
