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


  @override
  Widget build(BuildContext context) {
    var homeBannerDataList = _homeBannerEntity.data;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                homeBannerDataList[index].imagePath,
                fit: BoxFit.fitWidth,
              );
            },
            itemCount: homeBannerDataList.length  ?? 0,
            pagination: SwiperPagination(),
            control: SwiperControl(),
            autoplay: true,
            duration: 1500,
          ),
          height: 180.0,
        )
    );
  }

  @override
  void initState() {
    super.initState();

    /// 初始化数据
    initDat();

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

  }
}


