import 'package:flutter/material.dart';

/// 基础页面
class BasePage extends StatefulWidget {
  /// 标题
  final String? title;

  /// appbar优先级高于title
  final PreferredSizeWidget? appbar;

  /// 内容
  final Widget child;

  /// appbar右侧功能按钮
  final List<Widget>? actions;

  /// 返回键和页面返回按钮
  final Future<bool> Function()? onWillPop;

  const BasePage(
      {Key? key,
      this.title,
      this.appbar,
      required this.child,
      this.actions,
      this.onWillPop})
      : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: WillPopScope(
        onWillPop: widget.onWillPop,
        // onWillPop: () {
        //   return Future.value(true);
        // },
        child: Stack(
          children: [
            //内容层
            widget.child,
            //页面错误层(如网络错误、重试等)
            ErrorPageWidget(),
            //加载弹窗层
            LoadingView(),
          ],
        ),
      ),
    );
  }

  /// 获取appbar
  PreferredSizeWidget? getAppBar() {
    if (widget.appbar != null) return widget.appbar;
    if (widget.title != null || widget.actions != null)
      return AppBar(
        title: Text(widget.title ?? ''),
        actions: widget.actions,
      );

    return null;
  }
}

/// 加载弹窗组件
class LoadingView extends StatelessWidget {
  /// 是否显示
  final bool showLoading;

  /// 加载弹窗显示的内容
  final String msg;

  const LoadingView({Key? key, this.showLoading = false, this.msg = '加载中...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //加载提示
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
                child: Text(msg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 网络出错展示组件
class ErrorPageWidget extends StatelessWidget {
  /// 错误内容
  final String? msg;

  /// 重新加载
  final void Function()? onReload;

  /// 是否显示
  final bool isShow;

  const ErrorPageWidget(
      {Key? key, this.msg, this.onReload, this.isShow = false})
      : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isShow,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("images/net_error.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(msg ?? ''),
            ),
            Visibility(
              visible: onReload != null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text(
                    '重新加载',
                  ),
                  onPressed: onReload,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
