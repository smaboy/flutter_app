import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';

class ShareWidget extends StatefulWidget {

  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {
//        print("我是分享");
        Toast.show("我是分享", context);
      },
    );
  }


}
