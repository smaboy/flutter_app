import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

/// 返回拦截
/// 只有当用户在一秒之内点击两次返回才退出app
class MyWillPopScope extends StatefulWidget {
  final Widget child;

  const MyWillPopScope({Key key, @required this.child}) : super(key: key);

  @override
  _MyWillPopScopeState createState() => _MyWillPopScopeState();
}

class _MyWillPopScopeState extends State<MyWillPopScope> {
  /// 上次点击时间
  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          _lastPressedAt = DateTime.now();

          //提示
          Toast.show("双击退出程序!!", context,duration: Toast.LENGTH_LONG);
          return false;
        }else{
          return true;
        }

      },
      child: Container(
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
