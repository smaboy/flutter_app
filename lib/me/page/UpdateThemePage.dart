import 'package:flutter/material.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';
import 'package:flutterapp/common/SPUtils.dart';
import 'package:flutterapp/common/event_bus_utils.dart';
import 'package:flutterapp/common/widget/theme_data_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateThemePage extends StatefulWidget {
  @override
  _UpdateThemePageState createState() => _UpdateThemePageState();
}

class _UpdateThemePageState extends State<UpdateThemePage> {

  int _selectedIndex;

  @override
  void initState() {
    super.initState();


    init();
  }

  void init() async {

    //初始化主题数据
    SharedPreferences sharedPreferences = await SPUtils.getInstance().getSP();
    try {
      _selectedIndex = sharedPreferences.getInt(SPUtils.themeData);
    } catch (e) {
      _selectedIndex = 0;
    }



  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("修改主题"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.keyboard_backspace),
        onPressed: (){
          RouteHelpUtils.pop(context);
        },),
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
                      border: Border.all(color: Theme.of(context).primaryColor,width: 0.5)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconButton(
                    icon: Icon(_selectedIndex == index ? Icons.check_box : Icons.check_box_outline_blank,),
                    color: Theme.of(context).primaryColor,
                    iconSize: 25.0,
                    onPressed: (){
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

  updateSelectedTheme(int value){
    setState(() {
      _selectedIndex = value;

      //将选择的主题保存
      SPUtils.getInstance().setValue(SPUtils.themeData, value);

      // 发送通知，主题改变了
      EventBusUtils.instance.fire(BusIEvent(busIEventID: BusIEventID.theme_update));
    });
  }
}
