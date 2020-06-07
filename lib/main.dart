import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:app2048/screens/game.dart';
import 'package:app2048/screens/home.dart';

void main() {
  runApp(App());
}

var routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => HomeScreen(),
  "/game": (BuildContext context) => Scaffold(body: GameScreen())
};

class App extends StatefulWidget {
  @override
  App({Key key}) : super(key: key);
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'FiraCode',
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}