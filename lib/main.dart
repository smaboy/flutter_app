import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutterapp/MainPage.dart';


void main() {
  runApp(new MyApp());
  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//      title: "Startup Name Generator",
      theme: new ThemeData(
        // 1.亮度
          brightness: Brightness.light,
          // 2.primarySwatch传入不是Color, 而是MaterialColor(包含了primaryColor和accentColor)
          primarySwatch: Colors.indigo,
          // 3.primaryColor: 单独设置导航和TabBar的颜色
//          primaryColor: Colors.indigo,
          // 4.accentColor: 单独设置FloatingActionButton\Switch
          accentColor: Colors.green,
          // 5.Button的主题
          buttonTheme: ButtonThemeData(
              height: 25,
              minWidth: 10,
              buttonColor: Colors.yellow
          ),
          // 6.Card的主题
          cardTheme: CardTheme(
              color: Colors.greenAccent,
              elevation: 10
          ),
          // 7.Text的主题
          textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 16, color: Colors.red),
            bodyText2: TextStyle(fontSize: 20),
//
            headline4: TextStyle(fontSize: 14),
            headline3: TextStyle(fontSize: 16),
            headline2: TextStyle(fontSize: 18),
            headline1: TextStyle(fontSize: 20),
          )
      ),
      darkTheme: ThemeData.dark(),
      home: new MainPage(),
    );
  }
}
