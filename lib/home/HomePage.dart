import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterapp/common/API.dart';
import 'package:flutterapp/common/webview_widget.dart';
import 'package:flutterapp/generated/json/home_article_list_entity_helper.dart';
import 'package:flutterapp/generated/json/home_banner_entity_helper.dart';
import 'package:flutterapp/http/HttpUtils.dart';

import 'entity/home_article_list_entity.dart';
import 'entity/home_banner_entity.dart';

/// 首页
class HomePage extends StatefulWidget {
  final String title;

  HomePage(this.title);

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  /// 轮播图数据
  HomeBannerEntity _homeBannerEntity = HomeBannerEntity();

  /// 文章列表数据
  HomeArticleListEntity _homeArticleListEntity = HomeArticleListEntity();
  SwiperController _swiperController;

  @override
  Widget build(BuildContext context) {
    List<HomeArticleListDataData> listData =
        _homeArticleListEntity?.data?.datas ?? <HomeArticleListDataData>[];
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
            itemCount: listData.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? getBannerWidget()
                  : getListViewItemWidget(listData[index - 1]);
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _swiperController = SwiperController();

    /// 初始化数据
    initDat();

    print("initState");
  }

  @override
  void dispose() {
    super.dispose();

    _swiperController.stopAutoplay();
    _swiperController.dispose();
    print("dispose");
  }

  /// 初始化数据
  void initDat() {
    ///获取轮播图数据
    initBannerData();
    initArticleListData();
  }

  /// 获取banner组件
  Widget getBannerWidget() {
    var homeBannerDataList = _homeBannerEntity.data;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Listener(
        onPointerDown: (tapDown) {
          //手指按下
          _swiperController.stopAutoplay();
        },
        onPointerUp: (tapUP) {
          //手指抬起
          _swiperController.startAutoplay();
        },
        child: Swiper(
          itemCount: homeBannerDataList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((10.0)), // 圆角度
                image: DecorationImage(
                  image: NetworkImage(homeBannerDataList[index].imagePath),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          loop: false,
          autoplay: false,
          autoplayDelay: 3000,
          //触发时是否停止播放
          autoplayDisableOnInteraction: true,
          duration: 1000,
          //默认分页按钮
//        control: SwiperControl(),
          controller: _swiperController,
          //默认指示器
          pagination: SwiperPagination(
            // SwiperPagination.fraction 数字1/5，默认点
            builder: DotSwiperPaginationBuilder(size: 6, activeSize: 9),
          ),

          //视图宽度，即显示的item的宽度屏占比
          viewportFraction: 0.8,
          //两侧item的缩放比
          scale: 0.9,

          onTap: (int index) {
            //点击事件，返回下标
            Navigator.of(context)
              ..push(MaterialPageRoute(builder: (context) {
                return WebViewWidget(
                  url: homeBannerDataList[index].url,
                  title: homeBannerDataList[index].title,
                );
              }));
          },
        ),
      ),
      height: 180.0,
    );
  }

  Widget getListViewItemWidget(
      HomeArticleListDataData homeArticleListDataData) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [ //阴影
              BoxShadow(
                  color:Colors.grey[300],
                  offset: Offset(2.0,2.0),
                  blurRadius: 2.0
              )
            ],
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Center(
              child: Padding(
                  child: Icon(Icons.favorite_border),
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0)),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  homeArticleListDataData.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 15.0),
                ),
                Padding(
                  child: Row(
                    children:
                        getListViewItemBottomWidget(homeArticleListDataData),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                )
              ],
            ))
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebViewWidget(
            url: homeArticleListDataData.link,
            title: homeArticleListDataData.title,
          );
        }));
      },
    );
  }

  /// 获取ListView的子view布局中底部的详情组件（如:作者、分类、时间等）
  List<Widget> getListViewItemBottomWidget(
      HomeArticleListDataData listDataData) {
    Widget tag = DecoratedBox(
      child: Text("新"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: Colors.red, width: 0.5),
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
    );
    var tags = <Widget>[];
    var spaceWidget = Container(
      width: 6.0,
    );

    ///开始创建组件数组
    /// 类型为1的为置顶文章，fresh为true的为最新文章,组件顺序按照置顶-新-tags顺序来
    if (listDataData.type == 1) {
      //置顶
      Widget tag = DecoratedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
          child: Text("置顶", style: TextStyle(fontSize: 10.0)),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.red[400], width: 1.0),
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
      );
      tags.add(tag);
    }
    if (listDataData.fresh == true) {
      //最新
      Widget tag = DecoratedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
          child: Text("新", style: TextStyle(fontSize: 10.0)),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.red, width: 1.0),
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
      );

      ///添加间距
      if (tags.length > 0) {
        tags.add(spaceWidget);
      }

      ///添加组件
      tags.add(tag);
    }
    if (listDataData.tags != null && listDataData.tags.length > 0) {
      //tags中的
      for (HomeArticleListDataDataTag tag in listDataData.tags) {
        Widget tempTag = DecoratedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
            child: Text(tag.name,
                style: TextStyle(fontSize: 10.0, color: Colors.green)),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            border: Border.all(color: Colors.green, width: 1.0),
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
        );

        Widget listener = GestureDetector(
          child: tempTag,
          onTap: () {
            ///单击走这
            Navigator.push(
              context,
              MaterialPageRoute(builder: (buildContext) {
                return WebViewWidget(
                  url: API.baseUrl + tag.url,
                  title: tag.name,
                );
              }),
            );
          },
        );

        ///添加间距
        if (tags.length > 0) {
          tags.add(spaceWidget);
        }

        ///添加组件
        tags.add(listener);
      }
    }
    String desc = "";

    ///分享人
    if (listDataData.shareUser != null && listDataData.shareUser.isNotEmpty) {
      desc += " 分享人: ${listDataData.shareUser}";
    }

    ///作者
    if (listDataData.shareUser != null && listDataData.shareUser.isNotEmpty) {
      desc += " 作者: ${listDataData.author}";
    }

    ///分类
    if (listDataData.shareUser != null && listDataData.shareUser.isNotEmpty) {
      desc +=
          " 分类: ${listDataData.superChapterName}/${listDataData.chapterName}";
    }

    ///时间
    if (listDataData.shareUser != null && listDataData.shareUser.isNotEmpty) {
      desc += " 时间: ${listDataData.niceDate}";
    }
    Widget tempDes = Expanded(child: Text(desc.trim(), style: TextStyle(fontSize: 10.0, color: Colors.grey),overflow: TextOverflow.ellipsis,),);
    ///添加间距
    if (tags.length > 0) {
      tags.add(spaceWidget);
    }

    ///添加组件
    tags.add(tempDes);
    return tags;
  }

  /// 从网络获取轮播图数据
  void initBannerData() async {
    Response responses = await HttpUtils.getInstance().get(API.homeBanner);

    //设置数据
    setState(() {
      _homeBannerEntity = homeBannerEntityFromJson(
          _homeBannerEntity, json.decode(responses.toString()));
      print("meBeanEntity转化的第一列的标题为:${_homeBannerEntity.data[0].title}");
    });

    _swiperController.startAutoplay();
  }

  /// 从网络获取文章列表数据
  void initArticleListData() async {
    Response responses = await HttpUtils.getInstance().get(API.homeArticleList);

    //设置数据
    setState(() {
      _homeArticleListEntity = homeArticleListEntityFromJson(
          _homeArticleListEntity, json.decode(responses.toString()));
      print(
          "initArticleListData-meBeanEntity转化的第一列的标题为:${_homeArticleListEntity.data.datas[0].title}");
    });
  }
}
