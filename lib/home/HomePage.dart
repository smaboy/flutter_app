import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterapp/common/constant/API.dart';
import 'package:flutterapp/common/util/RouteHelpUtils.dart';
import 'package:flutterapp/common/widget/webview_widget.dart';
import 'package:flutterapp/common/widget/error_page_widget.dart';
import 'package:flutterapp/common/widget/favorite_button_widget.dart';
import 'package:flutterapp/generated/json/home_banner_entity_helper.dart';
import 'package:flutterapp/home/MyDrawer.dart';
import 'package:flutterapp/home/entity/home_article_data.dart';
import 'package:flutterapp/home/entity/home_article_top_entity.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  /// 轮播图数据
  HomeBannerEntity _homeBannerEntity = HomeBannerEntity();

  /// 文章列表数据集合
  List<HomeArticleDataBean> _articleList = <HomeArticleDataBean>[];

  /// 轮播图控制器
  SwiperController _swiperController = SwiperController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// 是否展示网络出错页面
  bool isVisibleErrorPage = false;

  /// 网络出错页面提示信息
  String errorPageMsg = "";

  ///默认页码
  int curPageNum = 0;

  ScrollController _controller;
  bool showFloatBtn = false;
  double initOffSet = 0.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: isVisibleErrorPage
          ? ErrorPageWidget(
              msg: errorPageMsg,
            )
          : Container(
              color: Colors.grey[100],
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: ClassicFooter(),
                controller: _refreshController,
                onRefresh: reFreshData,
                onLoading: loadMoreData,
                child: ListView.builder(
                    controller: _controller,
                    itemCount: _articleList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index == 0
                          ? getBannerWidget()
                          : getListViewItemWidget(_articleList[index - 1]);
                    }),
              ),
            ),
      floatingActionButton: Visibility(
        visible: showFloatBtn,
        child: FloatingActionButton(
          child: Icon(Icons.arrow_upward),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            //返回到顶部时执行动画
            _controller.animateTo(.0,
                duration: Duration(milliseconds: 1500),
                curve: Curves.ease
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(() {
      //通过前后两次数据对比确定滑动方向

      print(_controller.offset); //打印滚动位置
      if (_controller.offset - initOffSet > 0 && showFloatBtn == false) {//向上滑动且按钮没有显示时，刷新显示按钮
        setState(() {
          showFloatBtn = true;
        });
      } else if (_controller.offset - initOffSet < 0 && showFloatBtn) {//向下滑动且按钮没有显示时，刷新显示按钮
        setState(() {
          showFloatBtn = false;
        });
      }

      //记录位置
      initOffSet = _controller.offset;
    });

    /// 初始化数据
    initDat();

  }

  @override
  void dispose() {
    super.dispose();

    _swiperController.stopAutoplay();
    _swiperController.dispose();
    _refreshController.dispose();
    _controller.dispose();
  }

  /// 初始化数据
  void initDat() {
    ///获取轮播图数据
    curPageNum = 0;
    initBannerData();
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
//            Navigator.of(context)
//              ..push(MaterialPageRoute(builder: (context) {
//                return WebViewWidget(
//                  url: homeBannerDataList[index].url,
//                  title: homeBannerDataList[index].title,
//                );
//              }));
            RouteHelpUtils.push(
                context,
                WebViewWidget(
                  url: homeBannerDataList[index].url,
                  title: homeBannerDataList[index].title,
                  des: homeBannerDataList[index].desc,
                ));
          },
        ),
      ),
      height: 180.0,
    );
  }

  Widget getListViewItemWidget(HomeArticleDataBean homeArticleDataBean) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              //阴影
              BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(2.0, 2.0),
                  blurRadius: 2.0)
            ],
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Center(
              child: FavoriteButtonWidget(
                isFavorite: homeArticleDataBean.collect ?? false,
                id: homeArticleDataBean.id,
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  homeArticleDataBean.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 15.0),
                ),
                Padding(
                  child: Row(
                    children: getListViewItemBottomWidget(homeArticleDataBean),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                )
              ],
            ))
          ],
        ),
      ),
      onTap: () {
        RouteHelpUtils.push(
            context,
            WebViewWidget(
              url: homeArticleDataBean.link,
              title: homeArticleDataBean.title,
              des: homeArticleDataBean.desc,
            ));
      },
    );
  }

  /// 获取ListView的子view布局中底部的详情组件（如:作者、分类、时间等）
  List<Widget> getListViewItemBottomWidget(
      HomeArticleDataBean homeArticleDataBean) {
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
    if (homeArticleDataBean.type == 1) {
      //置顶
      Widget tag = DecoratedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
          child: Text("置顶",
              style: TextStyle(fontSize: 10.0, color: Colors.red[400])),
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
    if (homeArticleDataBean.fresh == true) {
      //最新
      Widget tag = DecoratedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
          child: Text("新", style: TextStyle(fontSize: 10.0, color: Colors.red)),
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
    if (homeArticleDataBean.tags != null &&
        homeArticleDataBean.tags.length > 0) {
      //tags中的
      for (HomeArticleDataBeanTag tag in homeArticleDataBean.tags) {
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
            RouteHelpUtils.push(
                context,
                WebViewWidget(
                  url: API.baseUrl + tag.url,
                  title: tag.name,
                ));
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

    List<TextSpan> desTS = [];

    ///分享人
    if (homeArticleDataBean.shareUser != null &&
        homeArticleDataBean.shareUser.isNotEmpty) {
//      desc += "  分享人: ${homeArticleDataBean.shareUser}";
      TextSpan shareUserTS = TextSpan(
          text: "  分享人: ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: homeArticleDataBean.shareUser,
              style: TextStyle(color: Colors.black),
            )
          ]);
      desTS.add(shareUserTS);
    }

    ///作者
    if (homeArticleDataBean.author != null &&
        homeArticleDataBean.author.isNotEmpty) {
//      desc += "  作者: ${homeArticleDataBean.author}";
      TextSpan authorTS = TextSpan(
          text: "  作者: ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: homeArticleDataBean.author,
              style: TextStyle(color: Colors.black),
            )
          ]);
      desTS.add(authorTS);
    }

    ///分类
    if (homeArticleDataBean.superChapterName != null &&
        homeArticleDataBean.superChapterName.isNotEmpty &&
        homeArticleDataBean.chapterName != null &&
        homeArticleDataBean.chapterName.isNotEmpty) {
//      desc +=
//          "  分类: ${homeArticleDataBean.superChapterName}/${homeArticleDataBean.chapterName}";
      TextSpan chapterTS = TextSpan(
          text: "  分类: ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text:
                  "${homeArticleDataBean.superChapterName}/${homeArticleDataBean.chapterName}",
              style: TextStyle(color: Colors.black),
            )
          ]);
      desTS.add(chapterTS);
    }

    ///时间
    if (homeArticleDataBean.niceDate != null &&
        homeArticleDataBean.niceDate.isNotEmpty) {
//      desc += "  时间: ${homeArticleDataBean.niceDate}";
      TextSpan timeTS = TextSpan(
          text: "  时间: ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: homeArticleDataBean.niceDate,
              style: TextStyle(color: Colors.black),
            )
          ]);
      desTS.add(timeTS);
    }

    Widget tempDes = Expanded(
      child: Text.rich(
        TextSpan(children: desTS),
        style: TextStyle(fontSize: 10.0, color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
    );

    ///添加间距
    if (tags.length > 0) {
      tags.add(spaceWidget);
    }

    ///添加组件
    tags.add(tempDes);
    return tags;
  }

  /// 从网络获取轮播图数据
  void initBannerData() {
    HttpUtils.getInstance().get(API.homeBanner, onSuccess: (responses) {
      //设置数据
      setState(() {
        _homeBannerEntity = homeBannerEntityFromJson(
            _homeBannerEntity, json.decode(responses.toString()));
        print("meBeanEntity转化的第一列的标题为:${_homeBannerEntity.data[0].title}");
      });

      _swiperController.startAutoplay();

      //获取列表数据
      initArticleListData();
    }, onFailure: (msg) {
      //报错处理
      setState(() {
        isVisibleErrorPage = true;
        errorPageMsg = msg;
      });
    }, isNeedCache: true);
  }

  /// 从网络获取文章列表数据
  void initArticleListData() async {
    ///获取置顶文章列表数据
    Response homeArticleTop = await HttpUtils.getInstance().get(
        API.homeArticleTop,
        onSuccess: (responses) {},
        onFailure: (msg) {},
        isNeedCache: true);

    ///获取文章列表数据
    Response homeArticleList = await HttpUtils.getInstance().get(
        API.getHomeArticleList(curPageNum),
        onSuccess: (responses) {},
        onFailure: (msg) {},
        isNeedCache: true);
    print("homeArticleTop====${homeArticleTop.toString()}");
    print("homeArticleList====${homeArticleList.toString()}");

    //设置数据
    setState(() {
      ///整合数据r
      HomeArticleTopEntity homeArticleTopEntity = HomeArticleTopEntity()
          .fromJson(json.decode(homeArticleTop.toString()));
      HomeArticleListEntity homeArticleListEntity = HomeArticleListEntity()
          .fromJson(json.decode(homeArticleList.toString()));
      // 清空集合
      _articleList.clear();
      //添加数据到集合
      if (homeArticleTopEntity != null && homeArticleTopEntity.data != null) {
        //置顶文章数据
        _articleList.addAll(homeArticleTopEntity.data);
      }
      if (homeArticleListEntity != null &&
          homeArticleListEntity.data != null &&
          homeArticleListEntity.data.datas != null) {
        //文章数据
        _articleList.addAll(homeArticleListEntity.data.datas);
      }
      print(
          "initArticleListData-meBeanEntity转化的第一列的标题为:${_articleList[0].title},长度为:${_articleList.length}");
    });
  }

  /// 加载更多请求数据
  void loadMoreData() {
    ///获取文章列表数据
    curPageNum++;
    HttpUtils.getInstance().get(API.getHomeArticleList(curPageNum),
        onSuccess: (responses) {
      //设置数据
      setState(() {
        HomeArticleListEntity homeArticleListEntity =
            HomeArticleListEntity().fromJson(json.decode(responses.toString()));
        if (homeArticleListEntity != null &&
            homeArticleListEntity.data != null &&
            homeArticleListEntity.data.datas != null) {
          //文章数据
          _articleList.addAll(homeArticleListEntity.data.datas);
        }
        _refreshController.loadComplete();
      });
    }, onFailure: (msg) {
      _refreshController.loadFailed();
    });
  }

  /// 刷新数据
  void reFreshData() async {
    curPageNum++;
    initBannerData();
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;
}
