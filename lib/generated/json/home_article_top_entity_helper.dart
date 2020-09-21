import 'package:flutterapp/home/entity/home_article_data.dart';
import 'package:flutterapp/home/entity/home_article_top_entity.dart';

homeArticleTopEntityFromJson(HomeArticleTopEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new List<HomeArticleDataBean>();
		(json['data'] as List).forEach((v) {
			data.data.add(new HomeArticleDataBean().fromJson(v));
		});
	}
	if (json['errorCode'] != null) {
		data.errorCode = json['errorCode']?.toInt();
	}
	if (json['errorMsg'] != null) {
		data.errorMsg = json['errorMsg']?.toString();
	}
	return data;
}

Map<String, dynamic> homeArticleTopEntityToJson(HomeArticleTopEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['errorCode'] = entity.errorCode;
	data['errorMsg'] = entity.errorMsg;
	return data;
}