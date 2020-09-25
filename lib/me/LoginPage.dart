import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //默认不展示密码
  bool isLock = true;

  //密码输入框焦点
  var pwFocusNode = FocusNode();

  //密码输入框焦点
  var pw2FocusNode = FocusNode();

  String userNameErrorText = "";

  /// 当前页面类型(登录/注册)
  bool isLoginPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginPage ? "登录" : "注册"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(isLoginPage ? "注册" : "登录"),
            onPressed: () {
              setState(() {
                isLoginPage = !isLoginPage;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名",
                    helperText: "亲,请输入您的用户名!",
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        gapPadding: 5.0,
                        borderRadius:
                            BorderRadius.all(Radius.circular(5.0)))),
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  //编辑完成，焦点自动到密码输入框
                  FocusScope.of(context).requestFocus(pwFocusNode);
                },
                onChanged: (str) {},
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: TextField(
                focusNode: pwFocusNode,
                decoration: InputDecoration(
                    labelText: "登录密码",
                    hintText: "请输入密码",
                    helperText: "亲,请输入您的密码!",
                    prefixIcon: Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                      icon: isLock
                          ? Icon(Icons.lock_outline)
                          : Icon(Icons.lock_open),
                      onPressed: () {
                        setState(() {
                          isLock = !isLock;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        gapPadding: 10.0,
                        borderRadius:
                            BorderRadius.all(Radius.circular(5.0)))),
                keyboardType: TextInputType.visiblePassword,
                obscureText: isLock,
                onEditingComplete: () {
                  //编辑完成，焦点自动到密码输入框
                  FocusScope.of(context).requestFocus(pw2FocusNode);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Visibility(
                visible: !isLoginPage,
                child: TextField(
                  focusNode: pw2FocusNode,
                  decoration: InputDecoration(
                      labelText: "确认密码",
                      hintText: "请输入密码",
                      helperText: "亲,请确保输入的密码和前面一致哦!",
                      prefixIcon: Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        icon: isLock
                            ? Icon(Icons.lock_outline)
                            : Icon(Icons.lock_open),
                        onPressed: () {
                          setState(() {
                            isLock = !isLock;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0)))),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isLock,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (isLoginPage) {
                    //走登录校验逻辑

                    //走登录接口
                  } else {
                    //走注册校验逻辑

                    //走注册接口
                  }
                },
                child: Text(
                  isLoginPage ? "登录" : "注册",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
