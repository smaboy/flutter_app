class API{


  static String baseUrl ="https://www.wanandroid.com";

  /// ---------------首页相关-----------------///

  /// 页码
  static int pageNum = 0;
  /// 首页文章列表
  static String homeArticleList ="/article/list/$pageNum/json";
  /// 首页banner
  static String homeBanner ="/banner/json";
  /// 首页常用网站
  static String homeFriend ="/friend/json";
  /// 首页搜索热词
  static String homeHotKey ="/hotkey/json";
  /// 首页置顶文章
  static String homeArticleTop ="/article/top/json";


}