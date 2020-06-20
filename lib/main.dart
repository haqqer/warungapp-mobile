import 'package:flutter/material.dart';
import 'package:pembangunan/ui/pages/pembangunan.dart';
import 'package:pembangunan/ui/pages/home.dart';
import 'package:pembangunan/ui/pages/login.dart';

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
        '/pembangunan/create': (context) => PembangunanPage(),
      },
    );
  }
}
