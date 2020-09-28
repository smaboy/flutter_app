import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/common/API.dart';
import 'package:flutterapp/common/SPUtils.dart';
import 'package:flutterapp/http/HttpUtils.dart';
import 'package:flutterapp/me/entity/register_entity.dart';
import 'package:toast/toast.dart';

import 'entity/login_entity.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //默认不展示密码
  bool isLock = true;

  //用户名输入框控制器
  var userNameFocusNode = FocusNode();
  TextEditingController _userNameControl;

  //密码输入框焦点
  var pwFocusNode = FocusNode();
  TextEditingController _pwControl;

  //密码输入确认框焦点
  var pw2FocusNode = FocusNode();
  TextEditingController _pw2Control;

  String userNameErrorText = "";

  /// 当前页面类型(登录/注册)
  bool isLoginPage = true;


  @override
  void initState() {
    _userNameControl = TextEditingController();
    _pwControl = TextEditingController();
    _pw2Control = TextEditingController();

    //获取用户名和密码


    super.initState();
  }

  @override
  void dispose() {
    _userNameControl.dispose();
    _pwControl.dispose();
    _pw2Control.dispose();

    userNameFocusNode.dispose();
    pwFocusNode.dispose();
    pw2FocusNode.dispose();

    super.dispose();
  }

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
                controller: _userNameControl,
                focusNode: userNameFocusNode,
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
                controller: _pwControl,
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
                  controller: _pw2Control,
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
                  btnSubmit();
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

  ///点击按钮提交数据
  void btnSubmit() {
    //失去焦点，收起键盘
    userNameFocusNode.unfocus();
    pwFocusNode.unfocus();
    pw2FocusNode.unfocus();

    //登录注册逻辑
     if (isLoginPage && loginCheck()) {
      //走登录接口
      login();
    } else {
       if(registerCheck()){
         //走注册接口
         register();
       }
    }
  }

  bool loginCheck() {
    if(_userNameControl.text.isEmpty){
      Toast.show("用户名不能为空", context);
      userNameFocusNode.requestFocus();
//      FocusScope.of(context).requestFocus(pw2FocusNode);
    return false;
    }else if(_pwControl.text.isEmpty){
      Toast.show("密码不能为空", context);
      pwFocusNode.requestFocus();
//      FocusScope.of(context).requestFocus(pw2FocusNode);
    return false;
    }

    return true;
  }

  void login() {
    HttpUtils.getInstance().post(API.login,
    queryParameters: {
      "username" : _userNameControl.text,
      "password" : _pwControl.text,
    },
    onSuccess: (response){
      LoginEntity loginEntity = LoginEntity().fromJson(json.decode(response.toString()));
      if(loginEntity?.errorCode == 0){
        Toast.show("登录成功", context);
        SPUtils.getInstance().setValue("username", _userNameControl.text);
        SPUtils.getInstance().setValue("password", _pwControl.text);

        //关闭当前页面
        Navigator.pop(context);
      }else{
        Toast.show(loginEntity?.errorMsg ?? "登录失败", context);
      }

    },
    onFailure: (msg){
      Toast.show(msg, context);
    },
    isNeedCache: false);
  }

  bool registerCheck() {
    if(_userNameControl.text.isEmpty){
      Toast.show("用户名不能为空", context);
//      userNameFocusNode.requestFocus();
      FocusScope.of(context).requestFocus(userNameFocusNode);
      return false;
    }else if(_pwControl.text.isEmpty){
      Toast.show("密码不能为空", context);
//      pwFocusNode.requestFocus();
      FocusScope.of(context).requestFocus(pwFocusNode);
      return false;
    }else if(_pw2Control.text.isEmpty){
      Toast.show("确认密码不能为空", context);
//      pwFocusNode.requestFocus();
      FocusScope.of(context).requestFocus(pw2FocusNode);
      return false;
    }else if(_pw2Control.text.isEmpty != _pwControl.text.isEmpty){
      Toast.show("确认密码和密码不一致,请确保两者一致", context);
//      pwFocusNode.requestFocus();
      FocusScope.of(context).requestFocus(pw2FocusNode);
      return false;
    }

    return true;

  }

  void register() {
    HttpUtils.getInstance().post(API.register,
        queryParameters: {
          "username" : _userNameControl.text,
          "password" : _pwControl.text,
          "repassword" : _pw2Control.text,
        },
        onSuccess: (response){
          RegisterEntity registerEntity = RegisterEntity().fromJson(json.decode(response.toString()));
          if(registerEntity?.errorCode == 0){
            Toast.show("注册成功", context);
            SPUtils.getInstance().setValue("username", _userNameControl.text);
            SPUtils.getInstance().setValue("password", _pwControl.text);

            //关闭当前页面
            Navigator.pop(context);
          }else{
            Toast.show(registerEntity?.errorMsg ?? "注册失败", context);
          }
        },
        onFailure: (msg){
          Toast.show(msg, context);
        },
        isNeedCache: false);
  }




}
