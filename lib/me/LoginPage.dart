import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        flexibleSpace: Text("hhaha"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "用户名",
                    helperText: "用户名只能是英文大小写字母、@、*、_等字符",
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(
                        gapPadding: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "密码",
                    helperText: "密码只能是英文大小写字母、@、*、_等字符",
                    prefixIcon: Icon(Icons.vpn_key),
                    suffixIcon: Icon(Icons.lock_open),
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(
                        gapPadding: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "登录",
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(color: Colors.red[400], width: 1.0),
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                      colors: [ Colors.green, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
