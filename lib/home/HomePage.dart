import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterapp/entity/home_banner_entity.dart';
import 'package:flutterapp/generated/json/home_banner_entity_helper.dart';

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
  SwiperController _swiperController;

  @override
  Widget build(BuildContext context) {
    var homeBannerDataList = _homeBannerEntity.data;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
//          child: Swiper(
//            itemBuilder: (BuildContext context, int index) {
//              return Image.network(
//                homeBannerDataList[index].imagePath,
//                fit: BoxFit.fitWidth,
//              );
//            },
//            itemCount: homeBannerDataList?.length  ?? 0,
//            pagination: SwiperPagination(),
//            control: SwiperControl(),
//            autoplay: true,
//            duration: 1500,
//          ),
        child:  Listener(
          onPointerDown: (tapDown){
            //手指按下
            _swiperController.stopAutoplay();
          },
          onPointerUp: (tapUP){
            //手指抬起
            _swiperController.startAutoplay();
          },

          child: Swiper(
            itemCount: homeBannerDataList?.length  ?? 0,
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
            loop: true,
            autoplay: false,
            autoplayDelay: 3000,
            //触发时是否停止播放
            autoplayDisableOnInteraction: true,
            duration: 600,
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
              print("index-----" + index.toString());
            },
          ),
        ),
          height: 180.0,
        )
    );
  }

  @override
  void initState() {
    super.initState();

    _swiperController = SwiperController();

    /// 初始化数据
    initDat();

  }

  @override
  void dispose() {
    super.dispose();

    _swiperController.stopAutoplay();
    _swiperController.dispose();
  }

  /// 初始化数据
  void initDat() {
    ///获取轮播图数据
    initBannerData();

  }

  /// 从网络获取数据
  void initBannerData() async {
    var request = await HttpClient().getUrl(
        Uri.parse("https://www.wanandroid.com/banner/json"));
//    ///携带请求头
//    request.headers.add(name, value);
//    ///携带请求体
//    request.add(data);
//    request.addStream(stream);
    var responses = await request.close();
    String responsesBody = await responses.transform(utf8.decoder).join();
    print("获取到的数据为:$responsesBody");


    //设置数据
    setState(() {
      _homeBannerEntity = homeBannerEntityFromJson(_homeBannerEntity, json.decode(responsesBody));
      print("meBeanEntity转化的第一列的标题为:${_homeBannerEntity.data[0].title}");
    });

    _swiperController.startAutoplay();

  }
}


