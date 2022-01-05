import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/util/log_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// webview组件
class WebViewWidget extends StatefulWidget {
  final String? url;
  final String? title;
  final String? des;
  final bool showShare;

  const WebViewWidget(
      {Key? key, this.url, this.title, this.des, this.showShare = true})
      : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: WebView(
        initialUrl: widget.url ?? '',
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (value) {
          LogUtils.d('onProgress--$value');
        },
        onPageStarted: (value) {
          LogUtils.d('onPageStarted--$value');
        },
        onPageFinished: (value) {
          LogUtils.d('onPageFinished--$value');
        },
      ),
    );
  }
}
