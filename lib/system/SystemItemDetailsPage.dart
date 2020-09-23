import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'entity/system_tree_entity.dart';

/// 体系的一级标题详情页
class SystemItemDetailsPage extends StatefulWidget {
  ///标题
  final String title;

  ///页面数据
  final List<SystemTreeDataChild> list;

  ///当前位置
  final int position;

  const SystemItemDetailsPage({Key key, this.title, @required this.list, @required this.position})
      : super(key: key);

  @override
  _SystemItemDetailsPageState createState() => _SystemItemDetailsPageState();
}

class _SystemItemDetailsPageState extends State<SystemItemDetailsPage> {
  ///当前的位置
  int curPosition;
  List<Tab> myTabs;

//  final List<Tab> myTabs = <Tab>[
//    new Tab(text: '语文'),
//    new Tab(text: '数学'),
//    new Tab(text: '英语'),
//    new Tab(text: '化学'),
//    new Tab(text: '物理'),
//    new Tab(text: '政治'),
//    new Tab(text: '经济'),
//    new Tab(text: '体育'),
//  ];

  @override
  void initState() {
    super.initState();

    ///初始化位置设置
    curPosition = widget.position;

    ///tabs设置
    myTabs = widget.list
        .map((systemTreeDataChild) => Tab(
              text: systemTreeDataChild.name,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.position,
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          bottom: TabBar(
            isScrollable: true,
            tabs: myTabs,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: new TextStyle(fontSize: 16.0),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: new TextStyle(fontSize: 12.0),
          ),
        ),
        body: new TabBarView(
          children: myTabs.map((Tab tab) {
            return new Center(child: new Text(tab.text));
          }).toList(),
        ),
      ),
    );
  }
}
