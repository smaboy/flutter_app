import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/common/util/log_utils.dart';

class ProgressDialog extends Dialog {
  final String title;
  final String content;

  _showTimer(context) {
    var timer;
    timer = Timer.periodic(Duration(seconds: 3), (t) {
      LogUtils.d("关闭");
      Navigator.pop(context);
      timer.cancel();
    });
  }

  ProgressDialog(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    _showTimer(context);

    return Material(
      child: Center(
          child: Container(
        height: 200,
        width: 200,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Stack(
                children: <Widget>[
                  Align(
                    child: Text(title),
                    alignment: Alignment.topCenter,
                  ),
                  Align(
                    child: InkWell(
                      child: Icon(Icons.close),
                      onTap: () => Navigator.pop(context),
                    ),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              width: double.infinity,
              child: Text(
                content,
                textAlign: TextAlign.left,
              ),
              padding: EdgeInsets.all(10),
            )
          ],
        ),
      )),
      type: MaterialType.transparency,
    );
  }
}
