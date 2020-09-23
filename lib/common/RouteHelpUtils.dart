

import 'package:flutter/material.dart';

class RouteHelpUtils{


  static Future<dynamic> push(BuildContext context , Widget widget){
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (buildContext) {
          return widget;
        })
    );
  }


  static pop<T extends Object>(BuildContext context , Widget widget , [T result]){
    Navigator.of(context).pop(result);
  }
}