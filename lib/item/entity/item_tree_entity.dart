import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class ItemTreeEntity with JsonConvert<ItemTreeEntity> {
  List<ItemTreeData>? data;
  int? errorCode;
  String? errorMsg;
}

class ItemTreeData with JsonConvert<ItemTreeData> {
  List<dynamic>? children;
  int? courseId;
  int? id;
  String? name;
  int? order;
  int? parentChapterId;
  bool? userControlSetTop;
  int? visible;
}
