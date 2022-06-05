import 'package:uuid/uuid.dart';

class ThemeModel {
  String themeId;
  final String themeText;

  // 名前付きの必須パラメータでコンストラクタを作成
  ThemeModel({required this.themeText, this.themeId = 'dumy'});

  /// UUIDを生成して、返却する
  String createUUID() {
    const uuid = Uuid();
    return uuid.v1();
  }

  // getter
  String get getThemeText => themeText;
  String get getThemeId => themeId;
}
