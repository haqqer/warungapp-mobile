import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warungapp/data/endpoint.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/services/geo_service.dart';
import 'package:warungapp/services/login_service.dart';
import 'package:warungapp/services/warung_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  bool _isLoading = false;
  int navbarIndex = 0;
  List<Warung> _warungs = [];
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
    // getDataWarungs();
  }

  
  checkLoginStatus() async {
    bool status = await checkExpired();
    if(!status) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      getDataWarungs();
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

  getDataWarungs() async {
    setState(() {
      _isLoading = true;
    });    
    final result = await getWarungsAll();
    setState(() {
      _warungs = result;
      print(_warungs);
      _isLoading = false;
    });
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
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: Container(
                        height: 270,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                              onTap: () {
                                Navigator.pushNamed(context, '/warung');
                              },
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)
                                ),                    
                              ),
                          ),
                          SizedBox(height: 30),
                          Card(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: Text('Hai\nMau Makan Apa hari ini?', style: TextStyle(color: Colors.black54, fontSize: 20))
                            ),
                          ),                    

                        ],
                      ),
                    )
                  ],
                ),
                // RaisedButton(child: Text('Login'), onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)),
                // RaisedButton(child: Text('Warung'), onPressed: () => Navigator.pushNamed(context, '/warung'))
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.star, color: Colors.amber, size: 30),
                            onPressed: () {
                              print('test');
                            },
                          ),
                          Text('Favorit')
                        ]
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.place, color: Colors.red, size: 30),
                            onPressed: () {
                              Navigator.pushNamed(context, '/warung/location_arrond');
                            },
                          ),
                          Text('Lokasi')
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.yellow, size: 30),
                            onPressed: () {
                              print('ulasan');
                            },
                          ),
                          Text('Ulasan')
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Rekomendasi Warung ini', style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/warung');
                        },
                        child: Text('Lihat Semua >', style: TextStyle(color: Colors.black54))
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 120,
                  child:  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _warungs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        width: 80,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: _warungs[index].photos.length > 0 ? Image.network(UPLOAD+'/'+_warungs[index].photos[0].path, fit: BoxFit.fitWidth, alignment: FractionalOffset.center) : Icon(Icons.camera_alt),
                            ),
                            Text(_warungs[index].name)
                          ],
                        )
                      );
                    }
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Rekomendasi Makan ini', style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/warung');
                        },
                        child: Text('Lihat Semua >', style: TextStyle(color: Colors.black54))
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 120,
                  child:  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _warungs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        width: 80,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: _warungs[index].photos.length > 0 ? Image.network(UPLOAD+'/'+_warungs[index].photos[0].path, fit: BoxFit.fitWidth, alignment: FractionalOffset.center) : Icon(Icons.camera_alt),
                            ),
                            Text(_warungs[index].name)
                          ],
                        )
                      );
                    }
                  ),
                )
              ],
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
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height - 70);
    path.lineTo(size.width, 0);
    path.close();
    return path;    
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}