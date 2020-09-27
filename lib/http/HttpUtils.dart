import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutterapp/common/API.dart';
import 'package:cookie_jar/cookie_jar.dart';

/// Http工具类
///
/// dio的使用参考 https://github.com/flutterchina/dio/blob/master/README-ZH.md
///
class HttpUtils {
  static HttpUtils _instance;
  Dio dio;

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

    //添加拦截器
    dio.interceptors
      ..add(CookieManager(CookieJar())) //cookie管理
      ..add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        //请求拦截器
        print("------------------>>>>>>>>发送请求<<<<<<<————————————————————");
        print("请求方法:${options.method}");
        print("请求头:${options.headers}");
        print("请求参数:${options.queryParameters}");
        print("请求路径:${options.baseUrl}${options.path}");
        // Do something before request is sent
        return options; //continue
      }, onResponse: (Response response) {
        print("------------------>>>>>>>>接收响应<<<<<<<————————————————————");
        print("请求方法:${response.request.method}");
        print("请求头:${response.request.headers}");
        print("请求参数:${response.request.queryParameters}");
        print("请求路径:${response.request.baseUrl}${response.request.path}");
        print("响应状态码:${response.statusCode}");
        print("响应状态信息:${response.statusMessage}");
        print("响应头:${response.headers.toString()}");
        print("响应头数据:${response.toString()}");
        // Do something with response data
        return response; // continue
      }, onError: (DioError e) {
        print("------------------>>>>>>>>发生错误<<<<<<<————————————————————");
        // Do something with response error
        return e; //continue
      }))
      ..add(DioCacheManager(CacheConfig(baseUrl: API.baseUrl))
          .interceptor); //缓存拦截器
  }

  /// get 请求方法
  Future<Response> get(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      void Function(int, int) onReceiveProgress,
      void Function(Response) onSuccess,
      void Function(String) onFailure}) async {
    Response response;
    try {
      //  添加缓存配置 MaxAge：设置缓存的时间，MaxStale: 设置过期时常
      var optionTemp = buildCacheOptions(Duration(days: 7),
          maxStale: Duration(days: 10), subKey: "page=1", options: options);
      //开始请求
      response = await dio.get(path,
          queryParameters: queryParameters,
          options: optionTemp,
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
          options: options,
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
      case DioErrorType.CONNECT_TIMEOUT:
        errorMsg = "连接超时";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        errorMsg = "接收超时";
        break;
      case DioErrorType.SEND_TIMEOUT:
        errorMsg = "发送超时";
        break;
      case DioErrorType.CANCEL:
        errorMsg = "请求取消";
        break;
      case DioErrorType.RESPONSE:
        errorMsg = "服务器状态码错误";
        break;
      case DioErrorType.DEFAULT:
        errorMsg = "未知错误";
        break;
      default:
        errorMsg = "未知错误";
        break;
    }

    return errorMsg;
  }
}
