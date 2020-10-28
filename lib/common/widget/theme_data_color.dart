import 'dart:ui';

import 'package:flutter/material.dart';

/// 我的颜色
class MyColors {
  static const MaterialColor white = MaterialColor(0xFFFFFFFF, <int, Color>{
    50: Color(0xFF666666),
    100: Color(0xFF777777),
    200: Color(0xFF888888),
    300: Color(0xFF999999),
    400: Color(0xFFAAAAAA),
    500: Color(0xFFBBBBBB),
    600: Color(0xFFCCCCCC),
    700: Color(0xFFDDDDDD),
    800: Color(0xFFEEEEEE),
    900: Color(0xFFFFFFFF),
  });

  /// 颜色数组
  static List<MaterialColor> colors = [
    Colors.indigo,
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.green,
    Colors.pink,
    MyColors.white,
    Colors.red,
  ];

  /// 获取颜色
  static getColorByIndex(int index) {
    if (index >= colors.length) index = 0;
    return colors.elementAt(index);
  }
}
