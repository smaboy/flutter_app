import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class HomeArticleDataBean with JsonConvert<HomeArticleDataBean> {
  String apkLink;
  int audit;
  String author;
  bool canEdit;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String descMd;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int realSuperChapterId;
  int selfVisible;
  int shareDate;
  String shareUser;
  int superChapterId;
  String superChapterName;
  List<HomeArticleDataBeanTag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;
}

class HomeArticleDataBeanTag with JsonConvert<HomeArticleDataBeanTag>{
  String name;
  String url;
}