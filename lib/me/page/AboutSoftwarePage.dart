import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/common/webview_widget.dart';
import 'package:flutterapp/common/widget/theme_data_color.dart';

class AboutSoftwarePage extends StatefulWidget {
  @override
  _AboutSoftwarePageState createState() => _AboutSoftwarePageState();
}

class _AboutSoftwarePageState extends State<AboutSoftwarePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text("关于软件"),
                centerTitle: true,
                background: Image(
                  image: AssetImage("images/lake.jpg"),
                  fit: BoxFit.fill,
                ),
//                background: Image.network(
//                  'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
//                  fit: BoxFit.fitHeight,
//                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("   该软件采用flutter跨平台框架开发,采用玩安卓平台的开放API实现的功能,基本UI设计保持玩安卓平台样式。该app采用了大量优秀的第三方框架，如用于h5页面的flutter_webview_plugin、"
                    "用于网络请求的dio、用于下拉刷新的pull_to_refresh等等。该项目的主要目的是学习flutter框架，如有不足之处还请谅解。最后感谢API的提供者鸿洋大神，还有众多的优秀框架的提供者。",textScaleFactor: 0.7,),
              ),
              ListTile(
//                title: Text("关于作者: Smaboy"),
                title: Text.rich(TextSpan( text: "关于作者: ",
                    children: [
                      TextSpan(
                        text: "Smaboy",
                        style: TextStyle(color: Theme.of(context).primaryColor == MyColors.white ? Colors.blueAccent : Theme.of(context).primaryColor),
                      )
                    ])),
                onTap: (){
                  RouteHelpUtils.push(context, WebViewWidget(url: "https://github.com/smaboy",title: "Smaboy",showShare: false,));
                },
              ),
//              Divider(
//                color: Colors.grey,
//              ),
              ListTile(
//                title: Text("关于项目: flutter_app"),
                title: Text.rich(TextSpan( text: "关于项目: ",
                    children: [
                      TextSpan(
                        text: "flutter_app",
                        style: TextStyle(color: Theme.of(context).primaryColor == MyColors.white ? Colors.blueAccent : Theme.of(context).primaryColor),
                      )
                    ])),
                onTap: (){
                  RouteHelpUtils.push(context, WebViewWidget(url: "https://github.com/smaboy/flutter_app",title: "flutter_app",showShare: false,));
                },
              ),
//              Divider(
//                color: Colors.grey,
//              ),
              ListTile(
//                title: Text("关于玩安卓"),
                title: Text.rich(TextSpan( text: "关于API: ",
                    children: [
                      TextSpan(
                        text: "玩安卓开发API",
                        style: TextStyle(color: Theme.of(context).primaryColor == MyColors.white ? Colors.blueAccent : Theme.of(context).primaryColor),
                      )
                    ])),
                onTap: (){
                  RouteHelpUtils.push(context, WebViewWidget(url: "https://www.wanandroid.com/blog/show/2",title: "玩安卓",showShare: false,));
                },
              ),
//              Divider(
//                color: Colors.grey,
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
