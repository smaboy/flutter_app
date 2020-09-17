import 'package:flutterapp/generated/json/base/json_convert_content.dart';
import 'package:flutterapp/generated/json/base/json_field.dart';

class HomeBannerEntity with JsonConvert<HomeBannerEntity> {
	List<HomeBannerData> data;
	int errorCode;
	String errorMsg;
}

class HomeBannerData with JsonConvert<HomeBannerData> {
	String desc;
	int id;
	String imagePath;
	int isVisible;
	int order;
	String title;
	int type;
	String url;
}
