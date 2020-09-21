// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutterapp/home/entity/home_article_top_entity.dart';
import 'package:flutterapp/generated/json/home_article_top_entity_helper.dart';
import 'package:flutterapp/home/entity/home_article_list_entity.dart';
import 'package:flutterapp/generated/json/home_article_list_entity_helper.dart';
import 'package:flutterapp/home/entity/home_banner_entity.dart';
import 'package:flutterapp/generated/json/home_banner_entity_helper.dart';
import 'package:flutterapp/home/entity/home_article_data.dart';
import 'package:flutterapp/generated/json/home_article_data_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case HomeArticleTopEntity:
			return homeArticleTopEntityFromJson(data as HomeArticleTopEntity, json) as T;			case HomeArticleListEntity:
			return homeArticleListEntityFromJson(data as HomeArticleListEntity, json) as T;			case HomeArticleListData:
			return homeArticleListDataFromJson(data as HomeArticleListData, json) as T;			case HomeBannerEntity:
			return homeBannerEntityFromJson(data as HomeBannerEntity, json) as T;			case HomeBannerData:
			return homeBannerDataFromJson(data as HomeBannerData, json) as T;			case HomeArticleDataBean:
			return homeArticleDataBeanFromJson(data as HomeArticleDataBean, json) as T;			case HomeArticleDataBeanTag:
			return homeArticleDataBeanTagFromJson(data as HomeArticleDataBeanTag, json) as T;    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
		switch (type) {			case HomeArticleTopEntity:
			return homeArticleTopEntityToJson(data as HomeArticleTopEntity);			case HomeArticleListEntity:
			return homeArticleListEntityToJson(data as HomeArticleListEntity);			case HomeArticleListData:
			return homeArticleListDataToJson(data as HomeArticleListData);			case HomeBannerEntity:
			return homeBannerEntityToJson(data as HomeBannerEntity);			case HomeBannerData:
			return homeBannerDataToJson(data as HomeBannerData);			case HomeArticleDataBean:
			return homeArticleDataBeanToJson(data as HomeArticleDataBean);			case HomeArticleDataBeanTag:
			return homeArticleDataBeanTagToJson(data as HomeArticleDataBeanTag);    }
    return data as T;
  }
  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {			case 'HomeArticleTopEntity':
			return HomeArticleTopEntity().fromJson(json);			case 'HomeArticleListEntity':
			return HomeArticleListEntity().fromJson(json);			case 'HomeArticleListData':
			return HomeArticleListData().fromJson(json);			case 'HomeBannerEntity':
			return HomeBannerEntity().fromJson(json);			case 'HomeBannerData':
			return HomeBannerData().fromJson(json);			case 'HomeArticleDataBean':
			return HomeArticleDataBean().fromJson(json);			case 'HomeArticleDataBeanTag':
			return HomeArticleDataBeanTag().fromJson(json);    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {			case 'HomeArticleTopEntity':
			return List<HomeArticleTopEntity>();			case 'HomeArticleListEntity':
			return List<HomeArticleListEntity>();			case 'HomeArticleListData':
			return List<HomeArticleListData>();			case 'HomeBannerEntity':
			return List<HomeBannerEntity>();			case 'HomeBannerData':
			return List<HomeBannerData>();			case 'HomeArticleDataBean':
			return List<HomeArticleDataBean>();			case 'HomeArticleDataBeanTag':
			return List<HomeArticleDataBeanTag>();    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}