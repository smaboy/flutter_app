import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
//          child: new Text('Hello World'),
          child: new RandomWords(),

        ),
      ),
    );
  }
}
/// 有状态的类
class RandomWords extends StatefulWidget{
  @override
  createState() => new RandWordsState();

}

/// 为RandomWords提供状态，修改属性
class RandWordsState extends State<RandomWords>{
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new Text(wordPair.asPascalCase);
  }

}

