import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapp/common/API.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/common/SPUtils.dart';
import 'package:flutterapp/common/event_bus_utils.dart';
import 'package:flutterapp/common/myIcons.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/me/page/AboutSoftwarePage.dart';
import 'package:flutterapp/me/page/LoginPage.dart';
import 'package:flutterapp/me/page/MeFavoritePage.dart';
import 'package:flutterapp/me/page/UpdateThemePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //判断用户是否登录
  var isLogin = false;

  //用户名称
  var userName = "";

  //密码
  var password = "";

  //  记住密码
  var rememberPassword = false;

  StreamSubscription loginSubscription;

  @override
  void initState() {
    super.initState();

    initData();

    //注册EventBus
    initEvent();
  }

  void initEvent(){
     //注册EventBus
    loginSubscription = EventBusUtils.instance.register((BusIEvent event) {
      if(event.busIEventID == BusIEventID.login_success){
        initData();
      }else if(event.busIEventID == BusIEventID.logout_success){
        initData();
      }
    });
  }


  Future initData() async {
    SharedPreferences sharedPreferences = await SPUtils.getInstance().getSP();
    setState(() {
      isLogin = sharedPreferences.getBool(SPUtils.isLogin) ?? false;
      userName = sharedPreferences.getString(SPUtils.userName) ?? "";
      password = sharedPreferences.getString(SPUtils.password) ?? "";
      rememberPassword =
          sharedPreferences.getBool(SPUtils.rememberPassword) ?? false;
    });
  }

  @override
  void dispose() {
    loginSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.clip,
        alignment: Alignment.topLeft,
        children: <Widget>[
          Image.asset(
            "images/b01.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        "images/lake.jpg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.0,
                      ),
                    ),
                    Positioned(
                      left: 20.0,
                      bottom: 40.0,
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.person_pin,
                                color: Colors.black,
                                size: 30.0,
                              ),
                            ),
                            Text(
                              isLogin ? userName : "点击登录/注册",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () async {
                          //已经登录,不做操作
                          if (isLogin) return;
                          //进入登录注册页面
                          RouteHelpUtils.push(context, LoginPage());
                        },
                      ),
                    )
                  ],
                ),
                ListTile(
//              leading: Icon(Icons.favorite),
                  leading: Icon(
                    MyIcons.my_favorite,
                  ),
                  title: Text(
                    "我的收藏",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () async {
                    //点击进入我的收藏页面(需要判断是否登录)
                    if (isLogin) {
                      RouteHelpUtils.push(context, MeFavoritePage());
                    } else {
                      //进入登录注册页面
                      bool result =
                          await RouteHelpUtils.push(context, LoginPage());
                      if (result) initData();
                    }
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
           ListTile(
             leading: Icon(MyIcons.switch_theme),
             title: Text("切换主题"),
             onTap: () {
               //切换主题
               RouteHelpUtils.push(context, UpdateThemePage());
             },
           ),
           Divider(
             color: Colors.grey,
           ),
                ListTile(
                  leading: Icon(MyIcons.about_software),
                  title: Text(
                    "关于软件",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    //切换主题
                    RouteHelpUtils.push(context, AboutSoftwarePage());
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(MyIcons.clear_cache),
                  title: Text(
                    "清理缓存",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () async {
                    //清理缓存
                    HttpUtils.getInstance()
                        .showProgressDialog(context, "清理中...");
                    bool result = await HttpUtils.getInstance().clearAllCache();
                    Navigator.pop(context);
                    if (result) {
                      //清理成功
                      Toast.show("清理成功", context);
                    } else {
                      Toast.show("清理失败", context);
                    }
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
                        leading: Icon(MyIcons.log_out),
                        title: Text("退出登录"),
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            barrierLabel: "标题",
                            barrierDismissible: true,
                            transitionDuration: Duration(milliseconds: 400),
                            //这个是时间
                            barrierColor: Colors.black.withOpacity(0.5),
                            // 添加这个属性是颜色
                            pageBuilder: (BuildContext context,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return buildLogOutDialog(context);
                            },
                          );
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
        ],
      ),
    );
  }

  /// 退出登录操作
  void logout() {
    HttpUtils.getInstance().get(API.logout, onSuccess: (responses) {
      Map<String, dynamic> logoutBean = json.decode(responses.toString());
      if (logoutBean['errorCode'] == 0) {
        //退出成功
        //弹窗提示
        Toast.show("退出成功", context);
        //重置本地数据状态
        SPUtils.getInstance().setValue(SPUtils.isLogin, false);
        if (!rememberPassword) {
//          SPUtils.getInstance().setValue(SPUtils.userName, "");
          SPUtils.getInstance().setValue(SPUtils.password, "");
        }

        //发出通知
        EventBusUtils.instance.fire(BusIEvent(busIEventID: BusIEventID.logout_success));
      } else {
        //退出失败
        Toast.show(logoutBean['errorMsg'] ?? "退出失败", context);
      }
    }, onFailure: (msg) {
      Toast.show(msg, context);
    });
  }

  Dialog buildLogOutDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
              child: Text(
                "温馨提示",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            Container(
                padding: EdgeInsets.all(20.0),
                constraints: BoxConstraints(minHeight: 100.0),
                child: Text(
                  "您确定要退出登录吗?" * 1,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 13),
                )),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10.0)),
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: new Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "取消",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0),
                      ),
                    ),
                    onTap: () {
                      //关闭弹窗
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    child: new Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).primaryColor),
                      child: Text(
                        "确定",
                        style: TextStyle(
                            color: (Theme.of(context)
                                        .primaryColor
                                        .computeLuminance()) >
                                    0.5
                                ? Colors.black
                                : Colors.white,
                            fontSize: 15.0),
                      ),
                    ),
                    onTap: () {
                      //关闭弹窗
                      Navigator.pop(context);
                      //退出登录操作
                      logout();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
