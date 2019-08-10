import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
      routes: <String, WidgetBuilder>{
        '/memo': (BuildContext context) => MyHomePage(title: 'メモ画面')
      },
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future _login() async {
    var _result = await _auth.signInAnonymously();
    if (_result.user != null) {
      // ログインされた
      print('ログイン成功');
    } else {
      print('ログイン失敗');
    }
  }

  Future checkUserID() async {
    var user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
  }

  @override
  void initState() {
    super.initState();
    _login();
  }

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

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  Future _pageTransition() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/memo', (_) => false);
    }
  }

  Future _singUp(String email, String pass) async {
    if (email.isNotEmpty && pass.isNotEmpty) {
      var _result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      if (_result.user != null) {
        // ログイン成功
        Navigator.of(context).pushNamedAndRemoveUntil('/memo', (_) => false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pageTransition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'メールアドレス',
              border: OutlineInputBorder(),
            ),
            controller: _emailController,
            maxLines: 1,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'パスワード(確認)',
              border: OutlineInputBorder(),
            ),
            controller: _passwordController,
            maxLines: 1,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'パスワード(確認)',
              border: OutlineInputBorder(),
            ),
            controller: _passwordConfirmController,
            maxLines: 1,
          ),
          FlatButton(
            onPressed: () {
              if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _passwordController.text == _passwordConfirmController.text) {
                _singUp(_emailController.text, _passwordController.text);
              } else {
                print('入力内容に問題があります');
              }
            },
            color: Colors.blue,
            child: Text('登録する'),
          ),
        ],
      ),
    );
  }
}