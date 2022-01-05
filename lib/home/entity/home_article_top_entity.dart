import 'package:flutterapp/generated/json/base/json_convert_content.dart';

import 'home_article_data.dart';

class HomeArticleTopEntity with JsonConvert<HomeArticleTopEntity> {
  List<HomeArticleDataBean>? data;
  int? errorCode;
  String? errorMsg;
}
