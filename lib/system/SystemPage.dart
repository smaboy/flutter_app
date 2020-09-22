import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterapp/system/entity/system_tree_entity.dart';
import 'package:flutterapp/system/service/system_service_impl.dart';

class SystemPage extends StatefulWidget {
  ///标题
  final String title;

  const SystemPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SystemPageState();
  }
}

class SystemPageState extends State<SystemPage> {
  /// 标题数据
  SystemTreeEntity _systemTreeEntity;

  /// 被选中的一级标题,默认选中第一个
  int _selectedPosition = 0;

  ///应该展示的二级目录标题数据
  var _secondTitleData = SystemTreeData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: getTitleTreeWidget(),
    );
  }

  @override
  void initState() {
    super.initState();

    //初始化数据
    initTreeData();

    print("initState");
  }

  ///初始化标题数据
  void initTreeData() async {
    var data = await SystemServiceImpl.getInstance().getSystemTree();
    setState(() {
      //设置标题数据
      _systemTreeEntity = data;
      //设置二级标题数据
      if(_systemTreeEntity != null && _systemTreeEntity.data != null && _systemTreeEntity.data.length >0){
        _secondTitleData = _systemTreeEntity.data[_selectedPosition];
      }
    });
  }

  ///获取二级标题item组件集合
  List<Widget> getSecondTitleTreeItemWidgets(SystemTreeData systemTreeData) {
    var titleTreeWidgets = <Widget>[];
    if (systemTreeData != null &&
        systemTreeData.children != null &&
        systemTreeData.children.length > 0) {
      for (SystemTreeDataChild child in systemTreeData.children) {
        titleTreeWidgets.add(RaisedButton(
          child: Text(child.name),
          color: Colors.blue,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {}
        ));
      }

      print("第一个标题为:${systemTreeData.children[0].name}");
    }

    print("titleTreeWidgets的长度为:${titleTreeWidgets.length}");

    return titleTreeWidgets;
  }

  ///获取标题树组件
  Widget getTitleTreeWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: 100.0,
            child: ListView.separated(
                itemCount: _systemTreeEntity?.data?.length ?? 0,
                separatorBuilder: (buildContext, index) {
                  return Divider(height: 2.0, color: Colors.grey[400],);
                },
                itemBuilder: (BuildContext context, int index) {
//                  return ListTile(
//                    title: Text(_systemTreeEntity?.data[index].name,style: TextStyle(color: Colors.black,fontSize: 13.0),),
//                  );
                  return ListTile(
                    title: Text(_systemTreeEntity?.data[index].name,style: TextStyle(color: index == _selectedPosition ? Theme.of(context).primaryColor : Colors.black, fontSize: 13.0)),
                    onTap: (){
                      setState(() {
                        //设置被点击位置
                        _selectedPosition = index;
                        //设置应该被展示的二级标题
                        _secondTitleData = _systemTreeEntity.data[index];
                      });

                    },
                  );
                }),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10.0, // 主轴(水平)方向间距
                  runSpacing: 4.0, // 纵轴（垂直）方向间距
                  alignment: WrapAlignment.start, //沿主轴方向居中
                  children: getSecondTitleTreeItemWidgets(_secondTitleData),
                ),
              ),
            ),
          ), //一级标题
          //二级标题
        ],
      ),
    );
  }
}
