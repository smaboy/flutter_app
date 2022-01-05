import 'package:flutterapp/generated/json/base/json_convert_content.dart';

import 'home_article_data.dart';

class HomeArticleListEntity with JsonConvert<HomeArticleListEntity> {
  HomeArticleListData? data;
  int? errorCode;
  String? errorMsg;
}

class HomeArticleListData with JsonConvert<HomeArticleListData> {
  int? curPage;
  List<HomeArticleDataBean>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;
}
