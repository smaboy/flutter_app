import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutterapp/MainPage.dart';
import 'package:flutterapp/common/util/SPUtils.dart';
import 'package:flutterapp/common/util/event_bus_utils.dart';
import 'package:flutterapp/common/util/log_utils.dart';
import 'package:flutterapp/common/widget/my_will_pop_scope.dart';
import 'package:flutterapp/common/widget/theme_data_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //程序入口
  runApp(new MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor primaryColor = MyColors.white;
  MaterialColor primarySwatch = MyColors.white;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();

    super.dispose();
  }

  void init() async {
    //初始化主题数据
    SharedPreferences sharedPreferences = await SPUtils.getInstance().getSP();
    int position;
    try {
      position = sharedPreferences.getInt(SPUtils.themeData) ?? 0;
    } catch (e) {
      position = 0;
    }
    primaryColor = MyColors.getColorByIndex(position);
    primarySwatch = MyColors.getColorByIndex(position);
    LogUtils.d("_MyAppState--init--获取到的主题位置为==$position");

    //设置监听
    _streamSubscription = EventBusUtils.instance.register((event) {
      if (event.busIEventID == BusIEventID.theme_update) {
        int index;
        index = event.id ?? 0;
        LogUtils.d("_MyAppState--init--event-获取到的主题位置为==$index");
        setState(() {
          primaryColor = MyColors.getColorByIndex(index);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "my flutter",
      theme: new ThemeData(
        // 1.亮度
        brightness: Brightness.light,
        // 2.primarySwatch传入不是Color, 而是MaterialColor(包含了primaryColor和accentColor)
        primarySwatch: primaryColor,
        // 3.primaryColor: 单独设置导航和TabBar的颜色
        primaryColor: primaryColor,
        // // 4.accentColor: 单独设置FloatingActionButton\Switch
        // accentColor: Colors.green,
//         // 5.Button的主题
//         buttonTheme: ButtonThemeData(
//             height: 25, minWidth: 10, buttonColor: Colors.blueAccent),
//         // 6.Card的主题
//         cardTheme: CardTheme(color: Colors.greenAccent, elevation: 10),
//         // 7.Text的主题
//         textTheme: TextTheme(
//           bodyText1: TextStyle(fontSize: 16, color: Colors.red),
//           bodyText2: TextStyle(fontSize: 20),
// //
//           headline4: TextStyle(fontSize: 14),
//           headline3: TextStyle(fontSize: 16),
//           headline2: TextStyle(fontSize: 18),
//           headline1: TextStyle(fontSize: 20),
//         ),
      ),
      darkTheme: ThemeData.dark(),
      home: MyWillPopScope(
        child: MainPage(),
      ),
    );
  }
}
