import 'package:flutterapp/generated/json/base/json_convert_content.dart';

class SystemTreeEntity with JsonConvert<SystemTreeEntity> {
	List<SystemTreeData> data;
	int errorCode;
	String errorMsg;
}

class SystemTreeData with JsonConvert<SystemTreeData> {
	List<SystemTreeDataChild> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}

class SystemTreeDataChild with JsonConvert<SystemTreeDataChild> {
	List<dynamic> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}
