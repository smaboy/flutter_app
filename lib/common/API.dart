class API {
  static String baseUrl = "https://www.wanandroid.com";

  /// ---------------首页相关-----------------///

  /// 页码
  static int homePageNum = 0;

  /// 首页文章列表
  static String homeArticleList = "/article/list/$homePageNum/json";

  /// 首页banner
  static String homeBanner = "/banner/json";

  /// 首页常用网站
  static String homeFriend = "/friend/json";

  /// 首页搜索热词
  static String homeHotKey = "/hotkey/json";

  /// 首页置顶文章
  static String homeArticleTop = "/article/top/json";

  /// ---------------体系页面相关-----------------///

  /// 作者
  static String author = "";

  /// 体系数据
  static String systemTree = "/tree/json";

  /// 知识体系下的文章
  static String getSystemListByCid(int pageNum,int cid ){
    return "/article/list/$pageNum/json?cid=$cid";
  }

  /// 按照作者昵称搜索文章
  static String systemListByAuthor = "/article/list/0/json?author=鸿洋";


/// ---------------项目页面相关-----------------///

  ///项目页面分类标题
  static String itemTree = "/project/tree/json";

  ///项目页面集合文章
  static String getItemList(int pageNum,int cid ){
    return "/project/list/$pageNum/json?cid=$cid";
  }

}
