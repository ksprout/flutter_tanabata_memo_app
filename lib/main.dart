import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<MemoItem> _items = List();
  final TextEditingController _controller = TextEditingController();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'メモの内容',
                        border: OutlineInputBorder(),
                      ),
                      controller: _controller,
                      maxLines: 3,
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                  ),
                  FlatButton(
                    child: Text(
                      '追加する',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                    onPressed: (){
                      setState(() {
                        _items.add(MemoItem(
                          content: _controller.text,
                          createdAt: DateTime.now().add(Duration(hours: 9)),
                        ));
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/background.png',),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: Color(0xFFAAAAAA),
                              )
                          )
                      ),
                      child: Column(
                        children: _items,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoItem extends StatelessWidget {
  final String content;
  final DateTime createdAt;
  MemoItem({@required this.content, @required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Color(0xFFAAAAAA),
          )
        )
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment(-1, 0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment(1, 0),
            child: Text(
              '${createdAt.month}月${createdAt.day}日 ${createdAt.hour}時${createdAt.minute}分',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 12.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}