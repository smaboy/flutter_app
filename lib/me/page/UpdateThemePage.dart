import 'package:flutter/material.dart';
import 'package:flutterapp/common/RouteHelpUtils.dart';

class UpdateThemePage extends StatefulWidget {
  @override
  _UpdateThemePageState createState() => _UpdateThemePageState();
}

class _UpdateThemePageState extends State<UpdateThemePage> {
  List<Color> colors;

  int _selectedIndex;

  @override
  void initState() {
    super.initState();

    //初始化颜色
    colors = [
      Colors.red,
      Colors.blue,
      Colors.amber,
      Colors.cyan,
      Colors.deepPurple,
      Colors.green,
      Colors.pinkAccent,
      Colors.white,
      Colors.blueAccent,


    ];

    //初始化被选中的位置
    _selectedIndex = 0;
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

          print("index == $index");
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
                      color: colors.elementAt(index),
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
        itemCount: colors.length ?? 0,
      ),
    );
  }

  updateSelectedTheme(int value){
    setState(() {
      _selectedIndex = value;
    });
  }
}
