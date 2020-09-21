import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class HomeArticleListEntity with JsonConvert<HomeArticleListEntity> {
	HomeArticleListData data;
	int errorCode;
	String errorMsg;
}

class HomeArticleListData with JsonConvert<HomeArticleListData> {
	int curPage;
	List<HomeArticleListDataData> datas;
	int offset;
	bool over;
	int pageCount;
	int size;
	int total;
}

class HomeArticleListDataData with JsonConvert<HomeArticleListDataData> {
	String apkLink;
	int audit;
	String author;
	bool canEdit;
	int chapterId;
	String chapterName;
	bool collect;
	int courseId;
	String desc;
	String descMd;
	String envelopePic;
	bool fresh;
	int id;
	String link;
	String niceDate;
	String niceShareDate;
	String origin;
	String prefix;
	String projectLink;
	int publishTime;
	int realSuperChapterId;
	int selfVisible;
	int shareDate;
	String shareUser;
	int superChapterId;
	String superChapterName;
	List<HomeArticleListDataDataTag> tags;
	String title;
	int type;
	int userId;
	int visible;
	int zan;
}

class HomeArticleListDataDataTag with JsonConvert<HomeArticleListDataDataTag>{
	String name;
	String url;
}
