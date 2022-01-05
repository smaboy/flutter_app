import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class ItemListEntity with JsonConvert<ItemListEntity> {
  ItemListData? data;
  int? errorCode;
  String? errorMsg;
}

class ItemListData with JsonConvert<ItemListData> {
  int? curPage;
  List<ItemListDataData>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;
}

class ItemListDataData with JsonConvert<ItemListDataData> {
  String? apkLink;
  int? audit;
  String? author;
  bool? canEdit;
  int? chapterId;
  String? chapterName;
  bool? collect;
  int? courseId;
  String? desc;
  String? descMd;
  String? envelopePic;
  bool? fresh;
  int? id;
  String? link;
  String? niceDate;
  String? niceShareDate;
  String? origin;
  String? prefix;
  String? projectLink;
  int? publishTime;
  int? realSuperChapterId;
  int? selfVisible;
  int? shareDate;
  String? shareUser;
  int? superChapterId;
  String? superChapterName;
  List<ItemListDataDatasTag>? tags;
  String? title;
  int? type;
  int? userId;
  int? visible;
  int? zan;
}

class ItemListDataDatasTag with JsonConvert<ItemListDataDatasTag> {
  String? name;
  String? url;
}
