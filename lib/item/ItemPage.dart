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

/// 项目页面标题组件（各个分类标题组件）
class ItemPageTitleWidget extends StatefulWidget {
  @override
  _ItemPageTitleWidgetState createState() => _ItemPageTitleWidgetState();
}

class _ItemPageTitleWidgetState extends State<ItemPageTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();

    //组件的初始化数据在此方法中进行
    initData();
  }

  void initData() {}
}


/// 项目页面主要内容部分组件
class ItemPageContentWidget extends StatefulWidget {
  @override
  _ItemPageContentWidgetState createState() => _ItemPageContentWidgetState();
}

class _ItemPageContentWidgetState extends State<ItemPageContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();

    //组件的初始化数据在此方法中进行
    initData();
  }

  void initData() {


  }
}


