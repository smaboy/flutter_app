import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("登录",style: TextStyle(color: Colors.red,fontSize: 15.0,fontWeight: FontWeight.bold)),
        actions: <Widget>[
          RaisedButton(child: Text("注册",style: TextStyle(color: Colors.red,fontSize: 13.0),),onPressed: (){
            Toast.show("注册", context);
          },)
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
//            TextField(
//
//            ),
//            TextField(
//
//            ),
            Text("登录",style: TextStyle(color: Colors.red,fontSize: 15.0,fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}


