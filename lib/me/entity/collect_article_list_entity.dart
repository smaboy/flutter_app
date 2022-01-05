import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class CollectArticleListEntity with JsonConvert<CollectArticleListEntity> {
  CollectArticleListData? data;
  int? errorCode;
  String? errorMsg;
}

class CollectArticleListData with JsonConvert<CollectArticleListData> {
  int? curPage;
  List<CollectArticleListDataData>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;
}

class CollectArticleListDataData with JsonConvert<CollectArticleListDataData> {
  String? author;
  int? chapterId;
  String? chapterName;
  int? courseId;
  String? desc;
  String? envelopePic;
  int? id;
  String? link;
  String? niceDate;
  String? origin;
  int? originId;
  int? publishTime;
  String? title;
  int? userId;
  int? visible;
  int? zan;
}
