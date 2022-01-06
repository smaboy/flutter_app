import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/common/constant/API.dart';
import 'package:flutterapp/common/util/RouteHelpUtils.dart';
import 'package:flutterapp/common/util/toast_utils.dart';
import 'package:flutterapp/common/widget/webview_widget.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/me/entity/collect_article_list_entity.dart';

class MeFavoritePage extends StatefulWidget {
  @override
  _MeFavoritePageState createState() => _MeFavoritePageState();
}

class _MeFavoritePageState extends State<MeFavoritePage> {
  //页面数据
  List<CollectArticleListDataData>? articleList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: articleList?.length ?? 0,
          itemBuilder: (buildContext, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                  isThreeLine: true,
                  title: Text(
                    articleList![index].title ?? '',
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                  ),
                  subtitle: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                    child: Text(
                      "作者: ${articleList![index].author}  分类: ${articleList![index].chapterName}  收藏时间: ${articleList![index].niceDate}",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                  onTap: () {
                    RouteHelpUtils.push(
                        context,
                        WebViewWidget(
                          url: articleList![index].link,
                          title: articleList![index].title,
                          des: articleList![index].desc,
                        ));
                  },
                ),
                Divider(
                  color: Colors.grey,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 解决dependOnInheritedWidgetOfExactType<_LocalizationsScope>() or dependOnInheritedElement() was called before _MeFavoritePageState.initState() completed.
    Future.delayed(Duration.zero, () {
      initData();
    });
  }

  void initData() {
    HttpUtils.getInstance().showProgressDialog(context, "数据加载中...");
    HttpUtils.getInstance().get(API.getCollectArticleList(),
        onSuccess: (responses) {
      CollectArticleListEntity collectArticleListEntity =
          CollectArticleListEntity()
              .fromJson(json.decode(responses.toString()));
      if (collectArticleListEntity.data != null &&
          collectArticleListEntity.data!.datas != null) {
        setState(() {
          articleList = collectArticleListEntity.data!.datas;
        });
      }
      //关闭弹窗
      Navigator.pop(context);
    }, onFailure: (msg) {
      shortToast(msg);
      //关闭弹窗
      Navigator.pop(context);
    });
  }
}
