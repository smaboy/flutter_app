import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

/// EventBus工具类
class EventBusUtils {
  /// 实例
  static late EventBus _eventBus;

  // 工厂模式
  factory EventBusUtils() => _getInstance();

  static EventBusUtils get instance => _getInstance();
  static late EventBusUtils _instance;

  EventBusUtils._internal() {
    // 初始化
    if (_eventBus == null) {
      _eventBus = new EventBus(sync: true);
    }
  }

  static EventBusUtils _getInstance() {
    if (_instance == null) {
      _instance = new EventBusUtils._internal();
    }
    return _instance;
  }

  /// 注册
  StreamSubscription<BusIEvent> register(void onData(BusIEvent event),
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _eventBus.on<BusIEvent>().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  /// 发布事件
  void fire(BusIEvent event) {
    _eventBus.fire(event);
  }
}

/// EventBus事件
class BusIEvent {
  BusIEventID? busIEventID;
  dynamic obj;
  String? msg;
  int? id;

  BusIEvent({@required this.busIEventID, this.obj, this.msg, this.id});
}

enum BusIEventID {
  login_success,
  logout_success,
  theme_update,
  update_head_back_ground,
}
