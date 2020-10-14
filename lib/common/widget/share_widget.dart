import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';
import 'package:toast/toast.dart';

class ShareWidget extends StatefulWidget {
  final String title;
  final String text;
  final dynamic images;
  final String imageUrlAndroid;
  final String imagePathAndroid;
  final String url;
  final String titleUrlAndroid;
  final String musicUrlAndroid;
  final String videoUrlAndroid;
  final String filePath;
  final SSDKContentType contentType;

  const ShareWidget({
    Key key, this.title, this.text, this.images, this.imageUrlAndroid, this.imagePathAndroid, this.url, this.titleUrlAndroid, this.musicUrlAndroid, this.videoUrlAndroid, this.filePath, this.contentType,
  }) : super(key: key);

  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  @override
  void initState() {
    super.initState();

    ShareSDKRegister register = ShareSDKRegister();
    register.setupWechat("wx617c77c82218ea2c",
        "c7253e5289986cf4c4c74d1ccc185fb1", "https://www.sandslee.com/");
    register.setupSinaWeibo("568898243", "38a4f8204cc784f81f9f0daaf31e02e3",
        "http://www.sharesdk.cn");
    register.setupQQ("100371282", "aed9b0303e3ed1e27bae87c33761161d");
    register.setupFacebook(
        "1412473428822331", "a42f4f3f867dc947b9ed6020c2e93558", "shareSDK");
    register.setupTwitter("viOnkeLpHBKs6KXV7MPpeGyzE",
        "NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey", "http://mob.com");
    register.setupLinkedIn(
        "46kic3zr7s4n", "RWw6WRl9YJOcdWsj", "http://baidu.com");
    SharesdkPlugin.regist(register);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {
//        print("我是分享");
        showShareMenu();
      },
    );
  }

  /// 分享九宫格
  /// "https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png"
  void showShareMenu() {
    SSDKMap params = SSDKMap()
      ..setGeneral(
        widget.title,
        widget.text,
        [""],
        "https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png",
        "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png",
        widget.url,
        widget.url,
        null,
        null,
        null,
        SSDKContentTypes.webpage,
      );

    SharesdkPlugin.showMenu(null, params, (SSDKResponseState state,
        ShareSDKPlatform platform,
        Map userData,
        Map contentEntity,
        SSDKError error) {
      Toast.show(state.toString()+error.rawData.toString(), context);
//      showAlert(state, error.rawData, context);
    });
  }

}
