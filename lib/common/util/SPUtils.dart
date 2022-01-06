import 'package:shared_preferences/shared_preferences.dart';

/// 数据存储工具类
class SPUtils {
  static final String userName = "username";
  static String password = "password";
  static String isLogin = "isLogin";
  static String rememberPassword = "rememberPassword";
  static String themeData = "themeData";

  static SPUtils _instance = SPUtils._();

  SPUtils._();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static SPUtils getInstance() {
    return _instance;
  }

  Future<SharedPreferences> getSP() async {
    return await _prefs;
  }

  /// 设置数据
  setValue<T>(String key, T value) async {
    SharedPreferences sp = await getSP();
    if (value is int) {
      sp.setInt(key, value);
    } else if (value is bool) {
      sp.setBool(key, value);
    } else if (value is double) {
      sp.setDouble(key, value);
    } else if (value is String) {
      sp.setString(key, value);
    } else if (value is List<String>) {
      sp.setStringList(key, value);
    } else {
      throw Exception("不支持设置该类型的数据!");
    }
  }
}
