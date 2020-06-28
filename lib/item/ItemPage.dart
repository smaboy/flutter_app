import 'package:flutter/material.dart';

/// 项目页面
class ItemPage extends StatelessWidget {
  ///标题
  final String title;

  const ItemPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: Text("我是项目页面"),
        alignment: Alignment.center,
      ),
    );
  }
}
