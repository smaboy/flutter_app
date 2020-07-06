import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  ///标题
  final String title;

  const MePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("我是我的页面"),
            RaisedButton(
              onPressed: () {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("按钮一 ---> 您点击我了")));
              },
              child: Text("我是按钮一"),
              color: Colors.blue,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            RaisedButton.icon(
                onPressed: () {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("按钮二 ---> 您点击我了")));
                },
                icon: Icon(Icons.arrow_back),
                label: Text("我是按钮二")),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
