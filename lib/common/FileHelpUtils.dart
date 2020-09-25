


import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 文件操作类
class FileHelpUtils{

  ///---------------------文件名---------------------
  static const String HOME_BANNER = "home_banner.txt";
  static const String HOME_ARTICLE_LIST = "HOME_article_LIST.txt";
  static const String HOME_ARTICLE_TOP = "HOME_article_top.txt";


  /// 获取本地指定文件名的string内容
  static Future<String> getLocalFileStringContent(String fileName) async{
    try {
      //获取应用目录
      File file = await _getLocalFile(fileName);
      // 读取字符串
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      return "";
    }
  }

  /// 将string内容放到指定文件名的本地文件中
  static Future<bool> setStringContent2LocalFile(String fileName , String content) async{

    try {
      //获取应用目录
      File file = await _getLocalFile(fileName);
      // 读取字符串
      File fileTemp = await file.writeAsString(content);
      return fileTemp!=null && await fileTemp.exists();
    } on FileSystemException {
      return false;
    }

    return false;
  }

  static Future<File> _getLocalFile(String fileName) async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File("$dir/$fileName");
  }



}