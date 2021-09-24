import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/common/util/RouteHelpUtils.dart';
import 'package:flutterapp/common/widget/webview_widget.dart';
import 'package:flutterapp/common/widget/favorite_button_widget.dart';
import 'package:flutterapp/item/entity/item_list_entity.dart';
import 'package:flutterapp/item/entity/item_tree_entity.dart';
import 'package:flutterapp/item/service/item_service_impl.dart';

/// 项目页面
class ItemPage extends StatefulWidget {
  final String title;

  const ItemPage({Key key, this.title}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage>
    with AutomaticKeepAliveClientMixin {
  //项目子项集合
  List<ItemTreeData> data;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

  @override
  bool get wantKeepAlive => true;
}

/// 加载状态
enum LoadMoreStatue {
  //加载中
  STATUE_LOADING,
  //加载完成
  STATUE_COMPLETE,
  //空闲中
  STATUE_IDEL
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
  List<ItemListDataData> contentList = <ItemListDataData>[];

  ///当前页
  int curPageNum = 0;

  ScrollController _scrollController;
  VoidCallback _voidCallback;

  /// 加载更多的状态
  LoadMoreStatue curLoadMoreStatue = LoadMoreStatue.STATUE_IDEL;

  ///加载更多页面对应的内容
  String loadMoreMsg = "";

  @override
  Widget build(BuildContext context) {
    var length = contentList?.length ?? 0;
    return RefreshIndicator(
      onRefresh: () async {
        initData();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: length > 0 ? length + 1 : 0,
        itemBuilder: (buildContext, index) {
          return index == length
              ? LoadMoreWidget(
                  isVisibleProgress:
                      curLoadMoreStatue == LoadMoreStatue.STATUE_LOADING,
                  loadMoreMsg: loadMoreMsg,
                )
              : GestureDetector(
                  onTap: () {
                    RouteHelpUtils.push(
                        context,
                        WebViewWidget(
                          url: contentList[index].link,
                          title: contentList[index].title,
                          des: contentList[index].desc,
                        ));
                  },
                  child: Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Container(
                      height: 200.0,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Image.network(
                            contentList[index].envelopePic,
                            fit: BoxFit.contain,
                            width: 130.0,
                            height: 200.0,
                            alignment: Alignment.center,
                          ),
                          ContentEndWidget(
                              contentList: contentList, index: index),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //listview控制器
    _scrollController = ScrollController();
    _voidCallback = () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        //此时加载下一页数据
        if (curLoadMoreStatue == LoadMoreStatue.STATUE_IDEL && mounted) {
          //空闲状态才改变
          setState(() {
            loadMoreMsg = "加载中...";
            curLoadMoreStatue = LoadMoreStatue.STATUE_LOADING;

            //异步加载数据
            loadMoreData();
          });
        }
      }
    };
    _scrollController.addListener(_voidCallback);

    initData();
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.removeListener(_voidCallback);
    _scrollController.dispose();
  }

  void initData() async {
    curPageNum = 1;
    ItemListEntity itemListByCid = await ItemServiceImpl.getInstance()
        .getItemListByCid(curPageNum, widget.id);
    if (mounted) {
      setState(() {
        if (itemListByCid != null &&
            itemListByCid.data != null &&
            itemListByCid.data.datas != null) {
          contentList.clear();
          contentList.addAll(itemListByCid.data.datas);
        }
      });
    }
  }

  Future loadMoreData() async {
    curPageNum++;
    print("加载更多-当前页码为:$curPageNum");
    ItemListEntity itemListByCid = await ItemServiceImpl.getInstance()
        .getItemListByCid(curPageNum, widget.id);
    if (mounted) {
      setState(() {
        if (itemListByCid != null &&
            itemListByCid.data != null &&
            itemListByCid.data.datas != null &&
            itemListByCid.data.datas.length > 0) {
          curLoadMoreStatue = LoadMoreStatue.STATUE_IDEL;
          contentList.addAll(itemListByCid.data.datas);
        } else {
          loadMoreMsg = "已经到底了!!";
          curLoadMoreStatue = LoadMoreStatue.STATUE_COMPLETE;
        }
      });
    }
  }
}

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({
    Key key,
    this.isVisibleProgress = false,
    this.loadMoreMsg = "",
  }) : super(key: key);

  final bool isVisibleProgress;
  final String loadMoreMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: isVisibleProgress,
            child: SizedBox(
              width: 13.0,
              height: 13.0,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              loadMoreMsg,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 12.0),
            ),
          )
        ],
      ),
    );
  }
}

class ContentEndWidget extends StatelessWidget {
  const ContentEndWidget({
    Key key,
    @required this.contentList,
    @required this.index,
  }) : super(key: key);

  final List<ItemListDataData> contentList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            child: Text(
              contentList[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.all(5.0),
          ),
          Padding(
            child: Text(
              contentList[index].desc,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            padding: EdgeInsets.all(5.0),
          ),
          Expanded(
            child: Padding(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${contentList[index].niceDate}   ${contentList[index].author} ",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  FavoriteButtonWidget(
                    id: contentList[index].id,
                    isFavorite: contentList[index]?.collect ?? false,
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.0),
            ),
          ),
        ],
      ),
    );
  }
}
