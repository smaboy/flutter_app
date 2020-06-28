import 'package:flutter/material.dart';

class SystemPage extends StatelessWidget {
  ///标题
  final String title;

  const SystemPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: Text("我是体系页面"),
        alignment: Alignment.center,
      ),
    );
  }
}
