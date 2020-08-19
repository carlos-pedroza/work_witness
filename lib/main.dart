import 'package:flutter/material.dart';
import './src/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Work Witness',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColorDark: Colors.blueGrey[800],
          primaryColorLight: Colors.blueGrey[100],
          primaryColor: Colors.blueGrey[600],
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white, fontSize: 18),
            bodyText2: TextStyle(color: Colors.white, fontSize: 16),
            button: TextStyle(color: Colors.white, fontSize: 18),
            headline1: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            headline2: TextStyle(color: Colors.white, fontSize: 24),
            headline3: TextStyle(color: Colors.white, fontSize: 14),
            headline4: TextStyle(color: Colors.green[800], fontSize: 18),
            headline5: TextStyle(color: Colors.blue[800], fontSize: 18),
            caption: TextStyle(color: Colors.black87, fontSize: 16),
            subtitle2: TextStyle(color: Colors.blueGrey[800], fontSize: 20),
            subtitle1: TextStyle(color: Colors.black87, fontSize: 22),
          ),
          primaryTextTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
            button: TextStyle(color: Colors.white),
          ),
          cardTheme: CardTheme(
            color: Colors.blueGrey[100].withOpacity(0.75),
          ),
          dividerColor: Colors.blueGrey[400],
          accentColor: Colors.grey[500],
          iconTheme: IconThemeData(color: Colors.blueGrey[900])),
      home: Home(),
    );
  }
}
