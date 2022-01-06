import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/widget/theme_data_color.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/me/page/LoginPage.dart';

import '../constant/API.dart';
import '../util/RouteHelpUtils.dart';

///收藏按钮组件
class FavoriteButtonWidget extends StatefulWidget {
  ///是否收藏了
  final bool isFavorite;

  ///是否收藏了
  final int? id;

  const FavoriteButtonWidget({
    Key? key,
    this.isFavorite = false,
    this.id,
  }) : super(key: key);

  @override
  _FavoriteButtonWidgetState createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  bool? curIsFavorite;

  @override
  void initState() {
    super.initState();

    curIsFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        curIsFavorite ?? false ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).primaryColor == MyColors.white
            ? Colors.blueAccent
            : Theme.of(context).primaryColor,
      ),
      onPressed: () {
        //点击收藏的事件
        if (curIsFavorite ?? false) {
          //将此收藏移除
          HttpUtils.getInstance().post(API.getUnCollectOriginId(widget.id ?? 0),
              onSuccess: (responses) {
            Map<String, dynamic> map = jsonDecode(responses.toString());
            if (0 == map['errorCode']) {
              print("取消收藏成功");

              setState(() {
                curIsFavorite = !(curIsFavorite ?? false);
              });
            } else {
              print(map['errorMsg'] ?? "取消收藏失败");
            }
          }, onFailure: (msg) {
            print(msg);
          });
        } else {
          //添加收藏
          HttpUtils.getInstance()
              .post(API.getCollectArticleById(widget.id ?? 0),
                  onSuccess: (responses) {
            Map<String, dynamic> map = jsonDecode(responses.toString());
            if (0 == map['errorCode']) {
              print("收藏成功");
              setState(() {
                curIsFavorite = !(curIsFavorite ?? false);
              });
            } else if (-1001 == map['errorCode']) {
              //需要登录
              RouteHelpUtils.push(context, LoginPage());
            } else {
              print(map['errorMsg'] ?? "收藏失败");
            }
          }, onFailure: (msg) {
            print(msg);
          });
        }
      },
    );
  }
}
