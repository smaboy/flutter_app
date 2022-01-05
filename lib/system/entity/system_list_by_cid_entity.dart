import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class SystemListByCidEntity with JsonConvert<SystemListByCidEntity> {
  SystemListByCidData? data;
  int? errorCode;
  String? errorMsg;
}

class SystemListByCidData with JsonConvert<SystemListByCidData> {
  int? curPage;
  List<SystemListByCidDataData>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;
}

class SystemListByCidDataData with JsonConvert<SystemListByCidDataData> {
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
  dynamic shareDate;
  String? shareUser;
  int? superChapterId;
  String? superChapterName;
  List<dynamic>? tags;
  String? title;
  int? type;
  int? userId;
  int? visible;
  int? zan;
}
