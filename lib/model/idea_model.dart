/**
 * ブレストしたいテーマに掛け合わせるキーワードを表示する
 */

// UUIDを生成するライブラリをインポート
import 'package:uuid/uuid.dart';

class IdeaModel {
  String randomKeyword = '';
  String ideaTheme = '';
  String idea = '';

  // 名前付きパラメータを持つコンストラクタ
  IdeaModel(
      {
      required this.randomKeyword,
      required this.ideaTheme,
      required this.idea
      });

  /// アイデアを引数にわたすと、IDやキーワードを生成するファクトリコンストラクタ
  factory IdeaModel.createIdea(String idea, String randomKeyword) {

    return new IdeaModel(
        randomKeyword: randomKeyword, ideaTheme: '農業', idea: idea);
  }
}
