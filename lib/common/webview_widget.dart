import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterapp/common/widget/share_widget.dart';

/// webview组件
class WebViewWidget extends StatefulWidget {
  final String url;
  final String title;
  final String des;
  final bool showShare;

  const WebViewWidget({Key key, this.url, this.title, this.des, this.showShare = true}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  StreamSubscription<double> _onProgressChanged;

  int _progressValue = 0;

  @override
  void initState() {
    super.initState();

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _progressValue = (progress * 100).toInt();
          print("webview当前进度为:progress=$progress");
          print("webview当前进度为:_progressValue=$_progressValue");
        });
      }
    });
  }

  @override
  void dispose() {
    _onProgressChanged.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Visibility(
            visible: widget.showShare,
            child: ShareWidget(title: widget.title,text: widget.des,url: widget.url,),
          ),
//          IconButton(
//            icon: Icon(Icons.more_horiz),
//            onPressed: () {
//              print("我是更多");
//            },
//          ),
        ],
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        alignment: Alignment.center,
        color: Colors.grey[400],
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
//            border: Border.all(//边框
//              color: Colors.blue,
//              width: 2.0,
//              style: BorderStyle.solid
//            ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(3.0, 3.0),
                    blurRadius: 4.0)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  child: Text(
                    '加载中$_progressValue%...',
                    textScaleFactor: 0.5,
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
