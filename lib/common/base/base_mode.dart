import 'package:flutter/material.dart';

/// 数据处理模型类
///
/// 这个类的子类会进行数据请求，数据存储
///
abstract class BaseModel extends ChangeNotifier {
  // // 这里可以默认配置一些常用的数据，比如登录数据等
  // bool isLogin = true;

  /// 当前model是否已经销毁
  bool _isDispose = false;

  /// 这是一个初始化方法，用于属性的初始化和数据获取
  Future<bool> init();

  @override
  void dispose() {
    super.dispose();

    _isDispose = true;
  }

  @override
  void notifyListeners() {
    //当前model销毁了，则不会再去通知监听器刷新
    if (!_isDispose) {
      super.notifyListeners();
    }
  }
}
