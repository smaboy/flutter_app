import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
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

    //Cookie管理
    dio.interceptors.add(CookieManager(CookieJar()));

    //添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("------------------>>>>>>>>请求之前<<<<<<<————————————————————");
      print("请求方法:${options.method}");
      print("请求头:${options.headers}");
      print("请求参数:${options.queryParameters}");
      print("请求路径:${options.baseUrl}${options.path}");
      // Do something before request is sent
      return options; //continue
    }, onResponse: (Response response) {
      print("------------------>>>>>>>>响应之前<<<<<<<————————————————————");
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      print("------------------>>>>>>>>错误之前<<<<<<<————————————————————");
      // Do something with response error
      return e; //continue
    }));
  }

  /// get 请求方法
  Future<Response> get(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      void Function(int, int) onReceiveProgress}) async {
    Response response;
    try {
      response = await dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);


      /// 打印get请求的的code和数据
      print("get请求的返回的状态码:${response.statusCode}");
      print("get请求返回的数据toString:${response.data}");
    } on DioError catch(e){
      print(e);
      response = Response(
        statusCode: -1,
        statusMessage: e.message
      );
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
      void Function(int, int) onReceiveProgress}) async {
    Response response;
    try {
      response = await dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      /// 打印get请求的的code和数据
      print("post请求的状态码:${response.statusCode}");
      print("post请求的数据:${response.data}");
    } on DioError catch(e){

    }
    return response;
  }
}
