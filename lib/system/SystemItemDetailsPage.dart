import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 体系的一级标题详情页
class SystemItemDetailsPage extends StatefulWidget {
  @override
  _SystemItemDetailsPageState createState() => _SystemItemDetailsPageState();
}

class _SystemItemDetailsPageState extends State<SystemItemDetailsPage> {
  final List<Tab> myTabs = <Tab>[
    new Tab(text: '语文'),
    new Tab(text: '数学'),
    new Tab(text: '英语'),
    new Tab(text: '化学'),
    new Tab(text: '物理'),
    new Tab(text: '政治'),
    new Tab(text: '经济'),
    new Tab(text: '体育'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("test"),
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
      ),
    );
  }
}
