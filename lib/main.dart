import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warungapp/provider/provider_auth.dart';
import 'package:warungapp/ui/pages/home.dart';
import 'package:warungapp/ui/pages/login.dart';
import 'package:warungapp/ui/pages/warung/createWarung.dart';
import 'package:warungapp/ui/pages/warung/getWarungLocation.dart';
import 'package:warungapp/ui/pages/warung/listWarung.dart';
import 'package:warungapp/ui/pages/warung/locationWarung.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => ProviderAuth(),
    child: MyApp()
  )
);

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
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/warung': (context) => ListWarungPage(),
        '/warung/create': (context) => CreateWarungPage(),
        '/warung/location': (context) => GetWarungLocationPage(),
        '/warung/location_arrond': (context) => LocationWarungPage(),
      },
    );
  }
}
