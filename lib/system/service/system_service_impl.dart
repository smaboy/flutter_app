
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterapp/common/constant/API.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/system/entity/system_list_by_cid_entity.dart';
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
    Response responses = await HttpUtils.getInstance().get(API.systemTree,
        onSuccess: (responses){

        },
        onFailure: (msg){

        },
    isNeedCache: true);
    SystemTreeEntity systemTreeEntity = SystemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return systemTreeEntity;
  }

  @override
  getSystemListByAuthor(int pageNum, String author) async{
    Response responses = await HttpUtils.getInstance().get(API.systemListByAuthor,
        onSuccess: (responses){

        },
        onFailure: (msg){

        });
    SystemTreeEntity systemTreeEntity = SystemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return systemTreeEntity;
  }

  @override
  getSystemListByCid(int pageNum, int cid) async{

    Response responses = await HttpUtils.getInstance().get(API.getSystemListByCid(pageNum, cid),
        onSuccess: (responses){

        },
        onFailure: (msg){

        },
    isNeedCache: true);
    SystemListByCidEntity systemListByCidEntity = SystemListByCidEntity().fromJson(jsonDecode(responses.toString()));
    return systemListByCidEntity;
  }



}