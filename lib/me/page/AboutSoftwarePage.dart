import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/common/webview_widget.dart';

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
                icon: Icon(Icons.account_circle),
                onPressed: () async {},
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
              ListTile(
                title: Text("关于作者: Smaboy"),
                onTap: (){
                  RouteHelpUtils.push(context, WebViewWidget(url: "https://github.com/smaboy",title: "Smaboy",));
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text("关于项目: flutter_app"),
                onTap: (){
                  RouteHelpUtils.push(context, WebViewWidget(url: "https://github.com/smaboy/flutter_app",title: "flutter_app",));
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text("关于玩安卓"),
                onTap: (){
                  RouteHelpUtils.push(context, WebViewWidget(url: "https://www.wanandroid.com/index",title: "玩安卓",));
                },
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}