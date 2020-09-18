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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebviewScaffold(
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
          color: Colors.blueGrey,
          child: const Center(
            child: Text('加载中...'),
          ),
        ),
      ),
    );
  }
}
