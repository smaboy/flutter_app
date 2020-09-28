import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterapp/common/API.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/common/SPUtils.dart';
import 'package:flutterapp/common/widget/error_page_widget.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/me/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'MeFavoritePage.dart';

class MePage extends StatefulWidget {
  ///标题
  final String title;

  const MePage({Key key, this.title}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  //判断用户是否登录
  var isLogin = false;

  //用户名称
  var userName = "";

  //密码
  var password = "";

  @override
  void initState() {
    initData();

    super.initState();
  }

  Future initData() async {
    SharedPreferences sharedPreferences = await SPUtils.getInstance().getSP();
    setState(() {
      isLogin = sharedPreferences.getBool(SPUtils.isLogin) ?? false;
      userName = sharedPreferences.getString(SPUtils.userName) ?? "";
      password = sharedPreferences.getString(SPUtils.password) ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(title),
//        centerTitle: true,
//      ),
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                //进入登录注册页面
                RouteHelpUtils.push(context, LoginPage());
              },
            ),
//            title: Text("我是标题"),
            flexibleSpace: FlexibleSpaceBar(
              title: GestureDetector(
                child: Text(isLogin ? userName : "点击登录/注册"),
                onTap: () {
                  //已经登录,不做操作
                  if (isLogin) return;
                  //进入登录注册页面
                  RouteHelpUtils.push(context, LoginPage());
                },
              ),
              background: Image(
                image: AssetImage("images/lake.jpg"),
                fit: BoxFit.fill,
              ),
//              background: Image.network(
//                'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
//                fit: BoxFit.fitHeight,
//              ),
            ),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("我的收藏"),
              onTap: () {
                //点击进入我的收藏页面(需要判断是否登录)
                if (isLogin) {
                  RouteHelpUtils.push(context, MeFavoritePage());
                } else {
                  RouteHelpUtils.push(context, LoginPage());
                }
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("切换主题"),
              onTap: () {
                //切换主题
                Toast.show("切换主题功能构建中...", context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("关于软件"),
              onTap: () {
                //切换主题
                Toast.show("关于软件功能构建中...", context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            Visibility(
              visible: isLogin,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.warning),
                    title: Text("退出登录"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (buildContext) {
                            return AlertDialog(
                              title: Text("温馨提示"),
                              titlePadding: EdgeInsets.all(10.0),
                              content: Text("您确定要退出登录吗?"),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              actions: <Widget>[
                                FlatButton(child: Text("取消"),onPressed: (){
                                  Navigator.pop(context);
                                },),
                                FlatButton(child: Text("确定"),onPressed: (){
                                  //关闭弹窗
                                  Navigator.pop(context);
                                  //退出登录操作
                                  logout();
                                },)
                              ],
                            );
                          });
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  /// 退出登录操作
  void logout() {
    HttpUtils.getInstance().get(API.logout,
    onSuccess: (responses){
      Map<String,dynamic> logoutBean = json.decode(responses.toString());
      if(logoutBean['errorCode'] == 0){//退出成功
        SPUtils.getInstance().setValue(SPUtils.isLogin, false);
        SPUtils.getInstance().setValue(SPUtils.userName, "");
        SPUtils.getInstance().setValue(SPUtils.password, "");
      }else{//退出失败
        Toast.show(logoutBean['errorMsg'] ?? "退出失败", context);

      }
    },
    onFailure: (msg){
      Toast.show(msg, context);
    });

  }
}
