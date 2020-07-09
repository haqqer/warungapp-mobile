import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warungapp/services/geo_service.dart';
import 'package:warungapp/services/login_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  bool _isLoading = false;
  int navbarIndex = 0;
  List<BottomNavigationBarItem> _bottomNavbar = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home')
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      title: Text('Add Warung'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: Text('Profile')
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationPermission();
    checkLoginStatus();
  }

  
  checkLoginStatus() async {
    bool status = await checkExpired();
    if(!status) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
  
  _onNavbarTap(index) {
    if(index == 1) {
      Navigator.pushNamed(context, '/warung/location');
    } else {
      setState(() {
        navbarIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  // logout();
                },
              ),
              ListTile(
                title: Text('Help'),
                onTap: () {
                },
              )
            ]
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Pembangunan'),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  RaisedButton(child: Text('Login'), onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)),
                  RaisedButton(child: Text('Warung'), onPressed: () => Navigator.pushNamed(context, '/warung'))
                ],
              )
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavbar,
          onTap: _onNavbarTap,
          currentIndex: navbarIndex,
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;    
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}