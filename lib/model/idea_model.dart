/**
 * ブレストしたいテーマに掛け合わせるキーワードを表示する
 */

class IdeaModel {
  final String randomKeyword;
  final int themeId;
  final String ideaText;

  // 名前付きパラメータを持つコンストラクタ
  IdeaModel(
      {required this.randomKeyword,
      required this.ideaText,
      required this.themeId});

  /// アイデアを引数にわたすと、IDやキーワードを生成するファクトリコンストラクタ
  factory IdeaModel.createIdea(String ideaText, String randomKeyword) {
    return new IdeaModel(
        randomKeyword: randomKeyword, ideaText: ideaText, themeId: 0);
  }
}
