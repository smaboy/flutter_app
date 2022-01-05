import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class RegisterEntity with JsonConvert<RegisterEntity> {
  RegisterData? data;
  int? errorCode;
  String? errorMsg;
}

class RegisterData with JsonConvert<RegisterData> {
  bool? admin;
  List<dynamic>? chapterTops;
  int? coinCount;
  List<dynamic>? collectIds;
  String? email;
  String? icon;
  int? id;
  String? nickname;
  String? password;
  String? publicName;
  String? token;
  int? type;
  String? username;
}
