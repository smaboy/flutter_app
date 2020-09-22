

import 'package:dio/dio.dart';

/// 体系模块服务抽象类，这里提供所有相关服务的方法
abstract class SystemService{

  /// 获取体系数据
  getSystemTree();

  /// 获取知识体系下的文章
  ///
  /// 页码：拼接在链接上，从0开始。
  ///
  /// cid 分类的id，上述二级目录的id
  ///
  getSystemListByCid(int pageNum , int cid);

  /// 通过作者昵称获取文章
  ///
  /// 页码：拼接在链接上，从0开始。
  ///
  /// author：作者昵称，不支持模糊匹配。
  ///
  getSystemListByAuthor(int pageNum, String author);

}