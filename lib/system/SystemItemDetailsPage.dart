import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/util/RouteHelpUtils.dart';
import 'package:flutterapp/common/util/log_utils.dart';
import 'package:flutterapp/common/widget/webview_widget.dart';
import 'package:flutterapp/common/widget/favorite_button_widget.dart';
import 'package:flutterapp/system/entity/system_list_by_cid_entity.dart';
import 'package:flutterapp/system/service/system_service_impl.dart';

import 'entity/system_tree_entity.dart';

/// 体系的一级标题详情页
class SystemItemDetailsPage extends StatefulWidget {
  ///标题
  final String? title;

  ///页面数据
  final List<SystemTreeDataChild>? tabList;

  ///当前位置
  final int? position;

  const SystemItemDetailsPage(
      {Key? key, this.title, @required this.tabList, @required this.position})
      : super(key: key);

  @override
  _SystemItemDetailsPageState createState() => _SystemItemDetailsPageState();
}

class _SystemItemDetailsPageState extends State<SystemItemDetailsPage>
    with SingleTickerProviderStateMixin {
  ///当前的位置
  late int curPosition;

  ///当前tabs
  late List<Tab> myTabs;

  ///当前页码,初始值为0
  int curPageNum = 0;

  // 2. 初始化控制器（一般定义变量后放在initState()中初始化）
  late TabController tabController;

  late PageController pageController;

  //页面标签数据
  late List<SystemListByCidDataData> contentList;

  @override
  void initState() {
    super.initState();

    ///初始化位置设置
    curPosition = widget.position ?? 0;

    ///tabs设置
    myTabs = widget.tabList!
        .map((systemTreeDataChild) => Tab(
              text: systemTreeDataChild.name,
            ))
        .toList();

    // 2. 初始化控制器（一般定义变量后放在initState()中初始化）
    tabController = TabController(
        length: widget.tabList?.length ?? 0,
        vsync: this,
        initialIndex: widget.position ?? 0);
    pageController = PageController(initialPage: widget.position ?? 0);

    ///初始化网络数据
    intData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.search),onPressed: (){
//            Toast.show("搜索",context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
//          },)
//        ],
        centerTitle: true,
        title: Text(widget.title ?? ''),
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
          onTap: (int index) {
            LogUtils.d("system-tabbar-ontap-index-$index");
            curPosition = index;
            getListDataByCid();
          },
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: PageView.builder(
          controller: pageController,
          //禁止滑动
//        physics: NeverScrollableScrollPhysics(),
          itemCount: widget.tabList?.length ?? 0,
          onPageChanged: (index) {
            LogUtils.d("system-pageview-onPageChanged-index-$index");
            curPosition = index;
            getListDataByCid();
            tabController.animateTo(index);
          },
          itemBuilder: (buildContext, index) {
            return getContentWidget();
          },
        ),
      ),
    );
  }

  ///通过页码和cid获取指定的知识体系数据
  void getListDataByCid() async {
    ///获取当前tab对应的数据
    SystemListByCidEntity systemListByCidEntity =
        await SystemServiceImpl.getInstance().getSystemListByCid(
            curPageNum, widget.tabList![curPosition].id ?? 0);

    LogUtils.d("当前选中的position==$curPosition");

    //设置数据
    setState(() {
      if (systemListByCidEntity.data != null &&
          systemListByCidEntity.data!.datas != null) {
        contentList = systemListByCidEntity.data!.datas!;
      } else {
        contentList = <SystemListByCidDataData>[];
      }
    });

    LogUtils.d("第一个标题==${systemListByCidEntity.data!.datas![0].title}");
  }

  ///获取内容组件
  Widget getContentWidget() {
    var listView = ListView.builder(
        itemCount: contentList.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (buildContext, index) {
          return GestureDetector(
            onTap: () {
              RouteHelpUtils.push(
                  context,
                  WebViewWidget(
                    url: contentList[index].link,
                    title: contentList[index].title,
                    des: contentList[index].desc,
                  ));
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    //阴影
                    BoxShadow(
                        color: Colors.grey[300]!,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0)
                  ],
                  color: Colors.white),
              child: Row(
                children: <Widget>[
                  Center(
                    child: FavoriteButtonWidget(
                      isFavorite: contentList[index].collect ?? false,
                      id: contentList[index].id,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contentList[index].title ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 15.0),
                      ),
                      Padding(
                        child: getListViewItemBottomWidget(contentList[index]),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 0.0),
                      )
                    ],
                  ))
                ],
              ),
            ),
          );
        });

    return listView;
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    pageController.dispose();
  }

  void intData() {
    getListDataByCid();
  }

  getListViewItemBottomWidget(SystemListByCidDataData contentList) {
    String desc = "";

    ///分享人
    if (contentList.shareUser != null && contentList.shareUser!.isNotEmpty) {
      desc += " 分享人: ${contentList.shareUser}";
    }

    ///作者
    if (contentList.author != null && contentList.author!.isNotEmpty) {
      desc += " 作者: ${contentList.author}";
    }

    ///分类
    if (contentList.superChapterName != null &&
        contentList.superChapterName!.isNotEmpty &&
        contentList.chapterName != null &&
        contentList.chapterName!.isNotEmpty) {
      desc += " 分类: ${contentList.superChapterName}/${contentList.chapterName}";
    }

    ///时间
    if (contentList.niceDate != null && contentList.niceDate!.isNotEmpty) {
      desc += " 时间: ${contentList.niceDate}";
    }

    return Text(
      desc.trim(),
      style: TextStyle(fontSize: 10.0, color: Colors.grey),
      overflow: TextOverflow.ellipsis,
    );
  }
}
