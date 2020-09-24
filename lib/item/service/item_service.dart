/// 体系模块服务抽象类，这里提供所有相关服务的方法
abstract class ItemService{

  /// 获取体系数据
  getItemTree();

  /// 获取知识体系下的文章
  ///
  /// 页码：拼接在链接上，从0开始。
  ///
  /// cid 分类的id，上述二级目录的id
  ///
  getItemListByCid(int pageNum , int cid);


}