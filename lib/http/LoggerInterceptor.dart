import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterapp/common/util/log_utils.dart';

/// 日志拦截器
class LoggerInterceptor extends Interceptor {
  /// 请求日志
  StringBuffer reqLog = StringBuffer();

  /// 结果日志
  StringBuffer repLog = StringBuffer();

  /// 错误日志
  StringBuffer errLog = StringBuffer();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    reqLog.clear();
    reqLog.writeln("------------------>>>>>>>>发送请求<<<<<<<————————————————————");
    reqLog.writeln("请求url: ${options.baseUrl}${options.path}");
    reqLog.writeln("请求方法: ${options.method}");
    reqLog.writeln("请求头: \n${options.headers}");
    reqLog.writeln("请求参数: \n${options.queryParameters.toString()}");
    LogUtils.d(reqLog.toString());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    repLog.clear();
    repLog.writeln("------------------>>>>>>>>接收响应<<<<<<<————————————————————");
    repLog.writeln(
        "请求url: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
    repLog.writeln("请求方法: ${response.requestOptions.method}");
    repLog.writeln("请求头: \n${response.requestOptions.headers}");
    repLog
        .writeln("请求参数: ${response.requestOptions.queryParameters.toString()}");
    repLog.writeln();
    repLog.writeln("响应状态码: ${response.statusCode}");
    repLog.writeln("响应状态信息: ${response.statusMessage}");
    repLog.writeln("响应头: \n${response.headers.toString()}");
    if (response.data is Map || response.data is List) {
      String repMap = JsonEncoder.withIndent(' ').convert(response.data);
      repLog.writeln("响应数据:\n$repMap");
    } else {
      repLog.writeln("响应数据:${response.data.toString()}");
    }

    LogUtils.d(repLog.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    errLog.clear();
    repLog.writeln("------------------>>>>>>>>发生错误<<<<<<<————————————————————");
    errLog.writeln(err);
    LogUtils.e(errLog);

    super.onError(err, handler);
  }
}
