import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/common/constant/API.dart';
import 'package:flutterapp/common/util/RouteHelpUtils.dart';
import 'package:flutterapp/common/util/SPUtils.dart';
import 'package:flutterapp/common/util/event_bus_utils.dart';
import 'package:flutterapp/common/util/image_picker_utils.dart';
import 'package:flutterapp/common/util/toast_utils.dart';
import 'package:flutterapp/common/widget/myIcons.dart';
import 'package:flutterapp/common/widget/theme_data_color.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/me/page/AboutSoftwarePage.dart';
import 'package:flutterapp/me/page/LoginPage.dart';
import 'package:flutterapp/me/page/UpdateThemePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'page/MeFavoritePage.dart';

class MePage extends StatefulWidget {
  ///标题
  final String? title;

  const MePage({Key? key, this.title}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  Image _backGroundImage = Image(
    image: AssetImage("images/lake.jpg"),
    fit: BoxFit.fill,
  );
  final picker = ImagePicker();

  //判断用户是否登录
  var isLogin = false;

  //用户名称
  var userName = "";

  //密码
  var password = "";

  //  记住密码
  var rememberPassword = false;

  late StreamSubscription loginSubscription;

  @override
  void initState() {
    super.initState();

    //添加监听
    initEvent();

    initData();
  }

  void initEvent() {
    //注册EventBus
    loginSubscription = EventBusUtils.instance.register((BusIEvent event) {
      if (event.busIEventID == BusIEventID.login_success) {
        initData();
      } else if (event.busIEventID == BusIEventID.logout_success) {
        initData();
      } else if (event.busIEventID == BusIEventID.update_head_back_ground) {
        setState(() {});
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
    super.build(context);

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
              icon: Icon(
                Icons.account_circle,
                color: Colors.black,
                size: 30.0,
              ),
              onPressed: () async {
                //进入登录注册页面
                RouteHelpUtils.push(context, LoginPage());
              },
            ),
//            title: Text("我是标题"),
            flexibleSpace: FlexibleSpaceBar(
              title: GestureDetector(
                child: Text(isLogin ? userName : "点击登录/注册"),
                onTap: () async {
                  //已经登录,不做操作
                  if (isLogin) return;
                  //进入登录注册页面
                  RouteHelpUtils.push(context, LoginPage());
                },
              ),
              background: GestureDetector(
                child: _backGroundImage,
                onTap: () {
                  // getImage();
                  ImagePickerUtils.getInstance().showImagePickerDialog(context,
                      (image) {
                    _backGroundImage = image;
                    EventBusUtils.instance.fire(BusIEvent(
                        busIEventID: BusIEventID.update_head_back_ground));
                  }, showError: true);
                },
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
//              leading: Icon(Icons.favorite),
              leading: Icon(
                MyIcons.my_favorite,
                color: Theme.of(context).primaryColor == MyColors.white
                    ? Colors.blueAccent
                    : Theme.of(context).primaryColor,
              ),
              title: Text("我的收藏"),
              onTap: () async {
                //点击进入我的收藏页面(需要判断是否登录)
                if (isLogin) {
                  RouteHelpUtils.push(context, MeFavoritePage());
                } else {
                  //进入登录注册页面
                  RouteHelpUtils.push(context, LoginPage());
                }
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(
                MyIcons.switch_theme,
                color: Theme.of(context).primaryColor == MyColors.white
                    ? Colors.blueAccent
                    : Theme.of(context).primaryColor,
              ),
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
              leading: Icon(
                MyIcons.about_software,
                color: Theme.of(context).primaryColor == MyColors.white
                    ? Colors.blueAccent
                    : Theme.of(context).primaryColor,
              ),
              title: Text("关于软件"),
              onTap: () {
                //切换主题
                RouteHelpUtils.push(context, AboutSoftwarePage());
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(
                MyIcons.clear_cache,
                color: Theme.of(context).primaryColor == MyColors.white
                    ? Colors.blueAccent
                    : Theme.of(context).primaryColor,
              ),
              title: Text("清理缓存"),
              onTap: () async {
                //清理缓存
                HttpUtils.getInstance().showProgressDialog(context, "清理中...");
                bool result = await HttpUtils.getInstance().clearAllCache();
                Navigator.pop(context);
                if (result) {
                  //清理成功
                  shortToast("清理成功");
                } else {
                  shortToast("清理失败");
                }
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(
                MyIcons.check_update,
                color: Theme.of(context).primaryColor == MyColors.white
                    ? Colors.blueAccent
                    : Theme.of(context).primaryColor,
              ),
              title: Text("检测更新"),
              onTap: () {
                launch(
                    "https://www.pgyer.com/apiv2/app/install?_api_key=cd5a3a29a9eed4a3006665846e58e074&appKey=4fb01f94765f2e351d1e5448ad6c2f66&buildKey=&buildPassword=");
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
                    leading: Icon(
                      MyIcons.log_out,
                      color: Theme.of(context).primaryColor == MyColors.white
                          ? Colors.blueAccent
                          : Theme.of(context).primaryColor,
                    ),
                    title: Text("退出登录"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (buildContext) {
                            return buildLogOutDialog(context);
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

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _backGroundImage = Image.file(
          File(pickedFile.path),
          fit: BoxFit.fill,
        );
      } else {
        shortToast("No image selected.");
      }
    });
  }

  /// 退出登录操作
  void logout() {
    HttpUtils.getInstance().get(API.logout, onSuccess: (responses) {
      Map<String, dynamic> logoutBean = json.decode(responses.toString());
      if (logoutBean['errorCode'] == 0) {
        //退出成功
        //弹窗提示
        shortToast("退出成功");
        //重置本地数据状态
        SPUtils.getInstance().setValue(SPUtils.isLogin, false);
        if (!rememberPassword) {
//          SPUtils.getInstance().setValue(SPUtils.userName, "");
          SPUtils.getInstance().setValue(SPUtils.password, "");
        }

        //发出通知
        EventBusUtils.instance
            .fire(BusIEvent(busIEventID: BusIEventID.logout_success));
      } else {
        //退出失败
        shortToast(logoutBean['errorMsg'] ?? "退出失败");
      }
    }, onFailure: (msg) {
      shortToast(msg);
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

  @override
  bool get wantKeepAlive => true;
}
