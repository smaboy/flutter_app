import 'package:flutter/material.dart';
import 'package:flutterapp/common/util/SPUtils.dart';
import 'package:flutterapp/common/util/event_bus_utils.dart';
import 'package:flutterapp/common/util/log_utils.dart';
import 'package:flutterapp/common/widget/theme_data_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateThemePage extends StatefulWidget {
  @override
  _UpdateThemePageState createState() => _UpdateThemePageState();
}

class _UpdateThemePageState extends State<UpdateThemePage> {
  /// 当前选中的主题
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    //初始化
    init();
  }

  void init() async {
    //初始化主题数据
    SharedPreferences sharedPreferences = await SPUtils.getInstance().getSP();
    try {
      _selectedIndex = sharedPreferences.getInt(SPUtils.themeData) ?? 0;
    } catch (e) {
      _selectedIndex = 0;
    }
    setState(() {
      _selectedIndex = _selectedIndex;
    });

    LogUtils.d("_UpdateThemePageState--init--获取到的主题坐标为:$_selectedIndex");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("修改主题"),
        centerTitle: true,
        // leading: IconButton(icon: Icon(Icons.arrow_back_ios),
        // onPressed: (){
        //   RouteHelpUtils.pop(context);
        // },),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: index % 2 == 0 ? Colors.red : Colors.blue,
            height: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        color: MyColors.getColorByIndex(index),
                        borderRadius: BorderRadius.circular(20.0),
                        border: _selectedIndex == index
                            ? Border.all(color: Colors.black45, width: 1.0)
                            : null),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconButton(
                    icon: Icon(
                      _selectedIndex == index
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    color: Colors.black,
                    iconSize: 25.0,
                    onPressed: () {
                      updateSelectedTheme(index);
                    },
                  ),
                )
              ],
            ),
          );
        },
        itemCount: MyColors.colors.length,
      ),
    );
  }

  // 更新主题
  updateSelectedTheme(int value) {
    //更新选中位置
    setState(() {
      _selectedIndex = value;
    });

    // 发送通知，主题改变了
    EventBusUtils.instance.fire(
        BusIEvent(busIEventID: BusIEventID.theme_update, id: _selectedIndex));

    LogUtils.d(
        "_UpdateThemePageState--updateSelectedTheme--当前点击的位置是==$value--_selectedIndex==$_selectedIndex");
  }

  @override
  void dispose() {
    LogUtils.d(
        "_UpdateThemePageState--dispose--_selectedIndex==$_selectedIndex");

    //页面销毁时，将选中的主题保存
    SPUtils.getInstance().setValue(SPUtils.themeData, _selectedIndex);

    super.dispose();
  }
}
