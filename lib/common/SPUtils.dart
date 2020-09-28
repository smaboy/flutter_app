import 'package:shared_preferences/shared_preferences.dart';

/// 数据存储工具类
class SPUtils {
  static SPUtils _instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static SPUtils getInstance() {
    if (null == _instance) _instance = SPUtils();
    return _instance;
  }

  dynamic getValue(String key , [Type type]) async {
    SharedPreferences sp = await _prefs;
    if(type == null){
      return sp.get(key);
    }else{
      if (type is int) {
        return sp.getInt(key);
      } else if (type is bool) {
        return sp.getBool(key);
      } else if (type is double) {
        return sp.getDouble(key);
      } else if (type is String) {
        return sp.getString(key);
      } else if (type is List<String>) {
        return sp.getString(key);
      } else {
        throw Exception("不支持获取该类型的数据!");
      }
    }
  }

  /// 设置数据
  setValue<T>(String key, T value) async {
    SharedPreferences sp = await _prefs;
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
