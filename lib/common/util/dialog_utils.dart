import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 加载弹窗
showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
              'https://cdn.jsdelivr.net/gh/xvrh/lottie-flutter@master/example/assets/Mobilo/A.json',
              fit: BoxFit.fill,
              width: 80,
              height: 80,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('加载中...'),
              ),
            ),
          ],
        ),
      );
    },
  );
}
