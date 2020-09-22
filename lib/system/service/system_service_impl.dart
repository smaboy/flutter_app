
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterapp/common/API.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/system/entity/system_tree_entity.dart';
import 'package:flutterapp/system/service/system_service.dart';

class SystemServiceImpl extends SystemService{
  static SystemServiceImpl _instance;

  static SystemServiceImpl getInstance() {
    if (_instance == null) _instance = SystemServiceImpl();
    return _instance;
  }

  @override
  getSystemTree() async{
    Response responses = await HttpUtils.getInstance().get(API.systemTree);
    SystemTreeEntity systemTreeEntity = SystemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return systemTreeEntity;
  }

  @override
  getSystemListByAuthor(int pageNum, String author) async{
    Response responses = await HttpUtils.getInstance().get(API.systemTree);
    SystemTreeEntity systemTreeEntity = SystemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return systemTreeEntity;
  }

  @override
  getSystemListByCid(int pageNum, int cid) async{
    Response responses = await HttpUtils.getInstance().get(API.systemTree);
    SystemTreeEntity systemTreeEntity = SystemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return systemTreeEntity;
  }



}