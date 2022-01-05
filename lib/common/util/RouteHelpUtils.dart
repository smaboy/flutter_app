import 'package:flutter/material.dart';

class RouteHelpUtils {
  static Future<dynamic> push(BuildContext context, Widget widget) {
    return Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500), //动画时间为500毫秒
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation secondaryAnimation) {
        return new FadeTransition(
          //使用渐隐渐入过渡,
          opacity: animation,
          child: widget, //路由B
        );
      },
    )
        // MaterialPageRoute(builder: (buildContext) {
        //   return widget;
        // })
        );
  }

  static pop<T extends Object>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
