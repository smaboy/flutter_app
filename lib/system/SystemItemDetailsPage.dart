import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/system/entity/system_list_by_cid_entity.dart';
import 'package:flutterapp/system/service/system_service_impl.dart';

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

class _SystemItemDetailsPageState extends State<SystemItemDetailsPage> with SingleTickerProviderStateMixin{
  ///当前的位置
  int curPosition;

  ///当前tabs
  List<Tab> myTabs;

  ///当前页码,初始值为0
  int curPageNum = 0;

  // 2. 初始化控制器（一般定义变量后放在initState()中初始化）
  TabController tabController ;
  PageController pageController ;


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

    // 2. 初始化控制器（一般定义变量后放在initState()中初始化）
    tabController = TabController(length: widget.list.length, vsync: this, initialIndex: widget.position);
    pageController = PageController(initialPage: widget.position);

    ///初始化网络数据
    intData();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: myTabs,
          // 线条宽度
          // TabBarIndicatorSize.label 根据内容调整宽度
          // TabBarIndicatorSize.tab 根据(mainWidth/itemCount)调整宽度
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          labelStyle: new TextStyle(fontSize: 16.0),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: new TextStyle(fontSize: 12.0),
          // 线条边距
//          indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          // 点击item
          onTap: (int index){
            curPosition = index;
            // 切换到指定索引
            // curve 动画过度样式
            pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        //禁止滑动
//        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.list.length,
        onPageChanged: (index){
          tabController.animateTo(index);
        },
        itemBuilder:(buildContext,index){
          return Text("${widget.list[index].name}");
        },
        ),
      );
  }

  ///通过页码和cid获取指定的知识体系数据
  void getListDataByCid() async {
    ///获取当前tab对应的数据
    SystemListByCidEntity systemListByCidEntity= await SystemServiceImpl.getInstance().getSystemListByCid(curPageNum, widget.list[curPosition].id);
    print("第一个标题==${systemListByCidEntity.data.datas[0].title}");

  }


  void intData() {
    getListDataByCid();
  }
}
