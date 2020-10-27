import 'dart:ui';

import 'package:flutter/material.dart';

/// 我的颜色
class MyColors {
  /// 颜色数组
  static List<Color> colors = [
    Colors.indigo,
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.green,
    Colors.pinkAccent,
    Colors.white,
    Colors.blueAccent,
  ];

  /// 获取颜色
  static getColorByIndex(int index) {
    if (index >= colors.length) index = 0;
    return colors.elementAt(index);
  }
}
