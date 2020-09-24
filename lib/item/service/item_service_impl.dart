import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterapp/common/API.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/item/entity/item_list_entity.dart';
import 'package:flutterapp/item/entity/item_tree_entity.dart';
import 'package:flutterapp/item/service/item_service.dart';

class ItemServiceImpl extends ItemService{
  static ItemServiceImpl _instance;

  static ItemServiceImpl getInstance() {
    if (_instance == null) _instance = ItemServiceImpl();
    return _instance;
  }

  @override
  Future<ItemListEntity> getItemListByCid(int pageNum, int cid) async{
    Response responses = await HttpUtils.getInstance().get(API.getItemList(pageNum, cid));
    ItemListEntity itemListEntity = ItemListEntity().fromJson(jsonDecode(responses.toString()));
    return itemListEntity;
  }

  @override
  Future<ItemTreeEntity> getItemTree() async{
    Response responses = await HttpUtils.getInstance().get(API.systemTree);
    ItemTreeEntity itemTreeEntity = ItemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return itemTreeEntity;
  }

}