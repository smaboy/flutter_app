import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// webview组件
class WebViewWidget extends StatefulWidget {
  final String url;
  final String title;

  const WebViewWidget({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  StreamSubscription<double> _onProgressChanged;

  int _progressValue = 0 ;

  @override
  void initState() {
    super.initState();

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
          if (mounted) {
            setState(() {
              _progressValue = (progress*100).toInt();
              print("webview当前进度为:progress=$progress");
              print("webview当前进度为:_progressValue=$_progressValue");
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.pop(context);
        },),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: () {
            print("我是分享");
          },),
          IconButton(icon: Icon(Icons.more_horiz), onPressed: () {
            print("我是更多");
          },),

        ],
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        alignment: Alignment.center,
        color: Colors.grey[400],
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15.0),
          constraints: BoxConstraints.tightFor(width: 150,height: 150),
          decoration: BoxDecoration(
            color: Colors.white,
//            border: Border.all(//边框
//              color: Colors.blue,
//              width: 2.0,
//              style: BorderStyle.solid
//            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow:[
              BoxShadow(
                color: Colors.grey,
                offset: Offset(3.0,3.0),
                blurRadius: 4.0
              )
            ]


          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(child: Text('加载中$_progressValue%...',textScaleFactor: 0.5,),padding: EdgeInsets.all(10.0),),
            ],
          ),
        ),
      ),
    );
  }
}
