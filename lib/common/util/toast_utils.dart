import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 吐司工具类

/// 显示时间比较短暂的吐司
shortToast(
  String msg, {
  ToastGravity gravity = ToastGravity.CENTER,
  double fontSize = 16.0,
  Color? backgroundColor = Colors.grey,
  Color? textColor = Colors.white,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize);
}

/// 显示时间比较长久的吐司
longToast(
  String msg, {
  ToastGravity gravity = ToastGravity.CENTER,
  double fontSize = 16.0,
  Color? backgroundColor = Colors.grey,
  Color? textColor = Colors.white,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize);
}
