/**
 * ブレストしたいテーマに掛け合わせるキーワードを表示する
 */

class IdeaModel {
  final String randomKeyword;
  final String themeId;
  final String ideaText;

  // 名前付きパラメータを持つコンストラクタ
  IdeaModel(
      {required this.randomKeyword,
      required this.ideaText,
      required this.themeId});

  /// アイデアを引数にわたすと、IDやキーワードを生成するファクトリコンストラクタ
  factory IdeaModel.createIdea(String ideaText, String randomKeyword, String themeId) {
    return IdeaModel(
        randomKeyword: randomKeyword, ideaText: ideaText, themeId: themeId);
  }

  /// データをMap化して返す
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeId': themeId,
      'randomKeyword': randomKeyword,
      'ideaText': ideaText
    };
  }
}
