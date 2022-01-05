import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterapp/common/constant/API.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/item/entity/item_list_entity.dart';
import 'package:flutterapp/item/entity/item_tree_entity.dart';
import 'package:flutterapp/item/service/item_service.dart';

class ItemServiceImpl extends ItemService {
  static late ItemServiceImpl _instance;

  static ItemServiceImpl getInstance() {
    if (_instance == null) _instance = ItemServiceImpl();
    return _instance;
  }

  @override
  Future<ItemListEntity> getItemListByCid(int pageNum, int cid) async {
    Response responses = await HttpUtils.getInstance().get(
        API.getItemList(pageNum, cid),
        onSuccess: (responses) {},
        onFailure: (msg) {},
        isNeedCache: true);
    ItemListEntity itemListEntity =
        ItemListEntity().fromJson(jsonDecode(responses.toString()));
    return itemListEntity;
  }

  @override
  Future<ItemTreeEntity> getItemTree() async {
    Response responses = await HttpUtils.getInstance().get(API.itemTree,
        onSuccess: (responses) {}, onFailure: (msg) {}, isNeedCache: true);
    ItemTreeEntity itemTreeEntity =
        ItemTreeEntity().fromJson(jsonDecode(responses.toString()));
    return itemTreeEntity;
  }
}
