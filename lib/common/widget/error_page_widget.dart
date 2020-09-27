import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// 网络出错展示组件
class ErrorPageWidget extends StatefulWidget {
  final String msg;

  const ErrorPageWidget({Key key, this.msg}) : super(key: key);
  @override
  _ErrorPageWidgetState createState() => _ErrorPageWidgetState();
}

class _ErrorPageWidgetState extends State<ErrorPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(widget.msg),
          )
        ],
      ),
    );
  }
}
