import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/item/entity/item_list_entity.dart';
import 'package:flutterapp/item/entity/item_tree_entity.dart';
import 'package:flutterapp/item/service/item_service_impl.dart';
import 'package:flutterapp/me/LoginPage.dart';

/// 项目页面
class ItemPage extends StatefulWidget {
  final String title;

  const ItemPage({Key key, this.title}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  //项目子项集合
  List<ItemTreeData> data;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: data?.length ?? 0,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              tabs: getTitleItems(),
            ),
          ),
          body: TabBarView(
            children: getContentItems(),
          )),
    );
  }

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() async {
    ItemTreeEntity itemTreeEntity =
        await ItemServiceImpl.getInstance().getItemTree();
    setState(() {
      if (itemTreeEntity != null &&
          itemTreeEntity.data != null &&
          itemTreeEntity.data.length > 0) {
        this.data = itemTreeEntity.data;
      }
    });
    print("ItemTreeEntity==第一个标题==${itemTreeEntity.data[0].name}");
  }

  /// 项目页面标题组件子项集合
  List<Widget> getTitleItems() {
    var tabs = <Tab>[];
    if (data != null && data.length > 0) {
      for (ItemTreeData itemTreeData in data) {
        tabs.add(Tab(
          child: Text(itemTreeData.name),
        ));
      }
    }
    return tabs;
  }

  /// 项目页面标题组件子项集合
  List<Widget> getContentItems() {
    var tabViewChildren = <ContentWidget>[];
    if (data != null && data.length > 0) {
      for (ItemTreeData itemTreeData in data) {
        tabViewChildren.add(ContentWidget(id: itemTreeData.id));
      }
    }
    print("tabViewChildren的长度为:${tabViewChildren.length}");
    return tabViewChildren;
  }
}

/// 内容组件
class ContentWidget extends StatefulWidget {
  final int id;

  const ContentWidget({Key key, @required this.id}) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  ///数据
  List<ItemListDataData> contentList;

  ///当前页
  int curPageNum = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contentList?.length ?? 0, itemBuilder: (buildContext,index){
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
            child: ListTile(
              title: Text(contentList[index].title),
              subtitle: Text(contentList[index].desc),
              leading: Image.network(contentList[index].envelopePic),
            ),
          );
    },);
  }

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() async {
    print(
        "_ContentWidgetState-initData-curPageNum-$curPageNum-id-${widget.id}");
    ItemListEntity itemListByCid = await ItemServiceImpl.getInstance()
        .getItemListByCid(curPageNum, widget.id);
    setState(() {
      if (itemListByCid != null &&
          itemListByCid.data != null &&
          itemListByCid.data.datas != null) {
        contentList = itemListByCid.data.datas;
      }
    });
    print("itemListByCid==第一个标题==${itemListByCid.data.datas[0].title}");
  }
}
