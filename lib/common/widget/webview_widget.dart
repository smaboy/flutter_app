import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterapp/common/base/base_page.dart';
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
  //是否显示加载弹窗
  bool showLoading = true;

  //加载进度
  int progress = 0;

  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _webViewController?.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.title ?? '',
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.home_outlined,
            )),
      ],
      onWillPop: () async {
        bool canGoBack = await _webViewController?.canGoBack() ?? false;
        if (canGoBack) {
          _webViewController?.goBack();
        } else {
          Navigator.pop(context);
        }
        return !canGoBack;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          WebView(
            initialUrl: widget.url ?? '',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) {
              _webViewController = webViewController;
            },
            onProgress: (value) {
              setState(() {
                progress = value;
                if (value >= 100) {
                  showLoading = false;
                } else {
                  showLoading = true;
                }
              });
            },
            onPageStarted: (value) {
              LogUtils.d('onPageStarted--$value');
            },
            onPageFinished: (value) {
              LogUtils.d('onPageFinished--$value');
            },
          ),
          //加载提示
          Visibility(
            visible: showLoading,
            child: UnconstrainedBox(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('加载中$progress%...'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
