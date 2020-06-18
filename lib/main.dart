import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warungapp_mobile/ui/pages/home.dart';
import 'package:warungapp_mobile/ui/pages/login.dart';
import 'package:warungapp_mobile/ui/warung/list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WarungApp Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder> {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/warungs/list': (context) => ListWarungPage(),
      },
    );
  }
}
