import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  ///标题
  final String title;

  const MePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: Text("我是我的页面"),
        alignment: Alignment.center,
      ),
    );
  }
}
