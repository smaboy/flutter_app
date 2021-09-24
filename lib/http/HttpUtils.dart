import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/constant/API.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

/// Http工具类
///
/// dio的使用参考 https://github.com/flutterchina/dio/blob/master/README-ZH.md
///
class HttpUtils {
  static HttpUtils _instance;
  Dio dio;
  DioCacheManager _dioCacheManager;
  PersistCookieJar _cookieJar;

  static HttpUtils getInstance() {
    if (_instance == null) _instance = HttpUtils();
    return _instance;
  }

  /// 构造器初始化配置在此内进行
  HttpUtils() {
// 或者通过传递一个 `options`来创建dio实例
    BaseOptions options = BaseOptions()
      ..baseUrl = API.baseUrl
      ..connectTimeout = 5000
      ..receiveTimeout = 3000;

    dio = Dio(options);

    _dioCacheManager = DioCacheManager(CacheConfig(baseUrl: API.baseUrl));

    //添加cookie拦截器
    addCookieInterceptors(dio);

    //添加拦截器
    dio.interceptors
//      ..add(CookieManager(CookieJar())) //cookie管理
      ..add(InterceptorsWrapper(onRequest: (options, handler) {
        //请求拦截器
        print("------------------>>>>>>>>发送请求<<<<<<<————————————————————");
        print("请求方法:${options.method}");
        print("请求头:${options.headers}");
        print("请求参数:${options.queryParameters.toString()}");
        print("请求路径:${options.baseUrl}${options.path}");
      }, onResponse: (response, handler) {
        print("------------------>>>>>>>>接收响应<<<<<<<————————————————————");
        print("请求头:${response.requestOptions.headers.toString()}");
        print("请求参数:${response.requestOptions.queryParameters.toString()}");
        print(
            "请求路径:${response.requestOptions.baseUrl}${response.requestOptions.path}");
        print("响应状态码:${response.statusCode}");
        print("响应状态信息:${response.statusMessage}");
        print("响应头:${response.headers.toString()}");
        print("响应数据:${response.toString()}");
      }, onError: (error, handler) {
        print("------------------>>>>>>>>发生错误<<<<<<<————————————————————");
        print("${error.message}");
      }))
      ..add(_dioCacheManager.interceptor); //缓存拦截器
  }

  ///添加cookie拦截器
  Future addCookieInterceptors(Dio dio) async {
    //默认cookie拦截器，将cookie保存在运存中，应用退出cookie销毁
//    add(CookieManager(CookieJar()))

    //cookie持久化，保存在文件中,用户手动销毁
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    // _cookieJar = PersistCookieJar(dir: "$appDocPath\/cookies/");
    _cookieJar =
        PersistCookieJar(storage: FileStorage("$appDocPath\/cookies/"));
    dio.interceptors.add(CookieManager(_cookieJar));
  }

  /// get 请求方法
  Future<Response> get(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      bool isNeedCache = false,
      void Function(int, int) onReceiveProgress,
      void Function(Response) onSuccess,
      void Function(String) onFailure}) async {
    Response response;
    try {
      //  添加缓存配置 MaxAge：设置缓存的时间，MaxStale: 设置过期时常
      //  subKey: dio-http-cache 默认使用 url 作为缓存 key ,但当 url 不够用的时候，比如 post 请求分页数据的时候，就需要配合subKey使用。
      //  forceRefresh默认为false,开启后先获取后台数据当后台数据获取不到或者网络出现问题,再去本地获取
      var optionTemp = buildCacheOptions(Duration(days: 7),
          maxStale: Duration(days: 10),
          subKey: "subPage",
          options: options,
          forceRefresh: true);
      //开始请求
      response = await dio.get(path,
          queryParameters: queryParameters,
          options: isNeedCache ? optionTemp : options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      //将成功的响应抛出
      if (onSuccess != null) {
        onSuccess(response);
      }
    } on DioError catch (e) {
      //将失败的响应抛出
      if (onFailure != null) {
        onFailure(handleError(e));
      }

      //打印请求报错信息
      print(e);
    }

    return response;
  }

  /// post 请求方法
  Future<Response> post(String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      bool isNeedCache = false,
      void Function(int, int) onSendProgress,
      void Function(int, int) onReceiveProgress,
      void Function(Response) onSuccess,
      void Function(String) onFailure}) async {
    Response response;
    try {
      //  添加缓存配置 MaxAge：设置缓存的时间，MaxStale: 设置过期时常
      var optionTemp = buildCacheOptions(Duration(days: 7),
          maxStale: Duration(days: 10), subKey: "page=1", options: options);
      //开始请求

      response = await dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: isNeedCache ? optionTemp : options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      //将成功的响应抛出
      if (onSuccess != null) {
        onSuccess(response);
      }
    } on DioError catch (e) {
      //将失败的响应抛出
      if (onFailure != null) {
        onFailure(handleError(e));
      }

      //打印请求报错信息
      print(e);
    }
    return response;
  }

  /// 处理错误
  String handleError(DioError e) {
    String errorMsg = "";
    switch (e.type) {
      case DioErrorType.connectTimeout:
        errorMsg = "连接超时";
        break;
      case DioErrorType.receiveTimeout:
        errorMsg = "接收超时";
        break;
      case DioErrorType.sendTimeout:
        errorMsg = "发送超时";
        break;
      case DioErrorType.cancel:
        errorMsg = "请求取消";
        break;
      case DioErrorType.response:
        errorMsg = "服务器状态码错误";
        break;
      case DioErrorType.other:
        errorMsg = e.message;
        break;
      default:
        errorMsg = e.message;
        break;
    }

    return errorMsg;
  }

  /// 显示加载对话框
  void showProgressDialog(BuildContext context, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: SizedBox(
              width: 280,
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(
                      value: .8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: Text(content),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  ///清除缓存
  Future<bool> clearAllCache() async {
    //清理所有缓存不管有没有过期
    return _dioCacheManager.clearAll();

//    //清理过期的缓存
//    _dioCacheManager.clearExpired()
  }

  /// 清除cookie
  clearAllCookie() {
    if (_cookieJar != null) {
      _cookieJar.deleteAll();
    }
  }
}
