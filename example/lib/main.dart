import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:facebook_sign_in/facebook_sign_in.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> read = ["public_profile", "user_friends", "email"];
  List<String> publish = ["publish_actions"];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Column(
          children: [
            new RaisedButton(
              child: new Text("Login"),
              onPressed: () async => print(await FacebookSignIn.loginWithReadPermissions(read)),
            ),
            new RaisedButton(
              child: new Text("Login"),
              onPressed: () async => print(await FacebookSignIn.loginWithPublishPermissions(publish)),
            ),
            new RaisedButton(
              child: new Text("Logout"),
              onPressed: () async => print(await FacebookSignIn.logout()),
            ),
          ]
        ),
      ),
    );
  }
  
}
