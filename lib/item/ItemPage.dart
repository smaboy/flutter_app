import 'package:flutter/material.dart';
import 'package:flutterapp/item/entity/item_list_entity.dart';
import 'package:flutterapp/item/entity/item_tree_entity.dart';
import 'package:flutterapp/item/service/item_service_impl.dart';

/// 项目页面
class ItemPage extends StatelessWidget {
  ///标题
  final String title;

  const ItemPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("我是项目页面"),
            ItemPageTitleWidget(),
            ItemPageContentWidget()
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

/// 项目页面标题组件（各个分类标题组件）
class ItemPageTitleWidget extends StatefulWidget {
  @override
  _ItemPageTitleWidgetState createState() => _ItemPageTitleWidgetState();
}

class _ItemPageTitleWidgetState extends State<ItemPageTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();

    //组件的初始化数据在此方法中进行
    initData();
  }

  void initData() async{
    ItemTreeEntity itemTreeEntity = await ItemServiceImpl.getInstance().getItemTree();
    print("ItemTreeEntity==第一个标题==${itemTreeEntity.data[0].name}");
  }
}


/// 项目页面主要内容部分组件
class ItemPageContentWidget extends StatefulWidget {
  @override
  _ItemPageContentWidgetState createState() => _ItemPageContentWidgetState();
}

class _ItemPageContentWidgetState extends State<ItemPageContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();

    //组件的初始化数据在此方法中进行
    initData();
  }

  void initData() async {
    ItemListEntity itemListByCid = await ItemServiceImpl.getInstance().getItemListByCid(0, 402);
    print("itemListByCid==第一个标题==${itemListByCid.data.datas[0].title}");


  }
}


