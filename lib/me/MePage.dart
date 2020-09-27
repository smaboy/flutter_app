import 'package:flutter/material.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/common/widget/error_page_widget.dart';
import 'package:flutterapp/me/LoginPage.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(title),
//        centerTitle: true,
//      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            leading: IconButton(icon: Icon(Icons.account_circle),onPressed: (){
              //进入登录注册页面
              RouteHelpUtils.push(context, LoginPage());
            },),
//            title: Text("我是标题"),
            flexibleSpace: FlexibleSpaceBar(
              title: GestureDetector(child: Text(isLogin ? userName : "点击登录/注册"),onTap: (){
                //进入登录注册页面
                RouteHelpUtils.push(context, LoginPage());
              },),
              background: Image(image: AssetImage("images/lake.jpg"),fit: BoxFit.fill,),
//              background: Image.network(
//                'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
//                fit: BoxFit.fitHeight,
//              ),
            ),
          )];
        },
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(leading: Icon(Icons.favorite) ,title: Text("我的收藏"),),
            Divider(color: Colors.grey,),
            ListTile(leading: Icon(Icons.dashboard) ,title: Text("切换主题"),),
            Divider(color: Colors.grey,),
            ListTile(leading: Icon(Icons.warning) ,title: Text("关于软件"),),
            Divider(color: Colors.grey,),
            ErrorPageWidget(msg: "请求超时",)
          ],
        ),
      ),
      )
    );

  }
}

