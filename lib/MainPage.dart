import 'package:flutter/material.dart';
import 'package:flutterapp/me/MePage.dart';
import 'package:flutterapp/system/SystemPage.dart';

import 'home/HomePage.dart';
import 'item/ItemPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 当前页面
  int _currentPage = 0;

  ///标题
  String title = "";

  /// 项目主色调
  Color mainColor = Colors.white;

  ///主页面标题
  static final pageTitles = ["首页", "体系", "项目", "我的"];

  ///所有主页面
  final pages = [
    HomePage(pageTitles[0]),
    SystemPage(title: pageTitles[1],),
    ItemPage(title: pageTitles[2],),
    MePage(title: pageTitles[3],)
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('首页'),
//        centerTitle: true,
//      ),
      body: pages[_currentPage],
      backgroundColor: mainColor,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          _currentPage = value;
        }),
        currentIndex: _currentPage,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text("首页"),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            title: Text("体系"),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.dvr),
            title: Text("项目"),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("我的"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  /// 处理底部tab点击
  void _switchPage(int value) {
    if (value != _currentPage) {
      setState(() {
        _currentPage = value;
      });
    }
  }
}
