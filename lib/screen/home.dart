import 'package:flutter/material.dart';
import 'package:flutter_brainstorming/screen/item_theme_list_view.dart';


/// アイデアテーマを登録・表示するView
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
