import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

/// EventBus工具类
class EventBusUtils {
  /// 实例
  EventBus _eventBus = EventBus(sync: true);

  static EventBusUtils _instance = EventBusUtils._internal();

  EventBusUtils._internal();

  static EventBusUtils get instance {
    return _instance;
  }

  /// 注册
  StreamSubscription<BusIEvent> register(void Function(BusIEvent)? onData,
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
