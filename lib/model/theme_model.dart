import 'package:flutter/material.dart';

class ThemeModel {
  final int themeId;
  final String themeText;

  // 名前付きの必須パラメータでコンストラクタを作成
  ThemeModel({required this.themeId, required this.themeText});

  factory ThemeModel.createTheme({required themeText}) {
    return ThemeModel(themeId: 0, themeText: themeText);
  }
}
