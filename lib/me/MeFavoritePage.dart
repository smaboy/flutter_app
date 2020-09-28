

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MeFavoritePage extends StatefulWidget {
  @override
  _MeFavoritePageState createState() => _MeFavoritePageState();
}

class _MeFavoritePageState extends State<MeFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
      ),
      body: Container(
        alignment:Alignment.center,
        child: Text("收藏页面"),
      ),
    );
  }
}
