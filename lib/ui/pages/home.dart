import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.blue
            ),
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    padding: EdgeInsets.only(left: 25, top: 30, right: 25),
                    height: 225,
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                  )
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari makan',
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3)
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Hai', style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                            SizedBox(height: 5),
                            Text('Mau makan apa hari ini', style: TextStyle(fontSize: 20.0, color: Colors.grey))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Icon(Icons.favorite_border,size: 48.0),
                      SizedBox(height: 5),
                      Text('Favorit')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.place, size: 48.0),
                      SizedBox(height: 5),
                      Text('Disekitar')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.update,size: 48.0),
                      SizedBox(height: 5),
                      Text('Posting')
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 5.0,
              color: Colors.grey[200],
            ),
            SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Rekomendasi hari ini',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey)
                        ),
                      ),
                      Spacer(),
                      Text('Lihat Semua >', style: TextStyle(fontSize: 14.0, color: Colors.grey))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                 Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 20.0,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.place, size: 48.0),
                        Text('Makanan'),
                        Text('5 Km')
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 20.0,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.place, size: 48.0),
                        Text('Makanan'),
                        Text('5 Km')
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 20.0,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.place, size: 48.0),
                        Text('Makanan'),
                        Text('5 Km')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 5.0,
              color: Colors.grey[200],
            ),
            SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Rekomendasi hari ini',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey)
                        ),
                      ),
                      Spacer(),
                      Text('Lihat Semua >', style: TextStyle(fontSize: 14.0, color: Colors.grey))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 20.0,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.place, size: 48.0),
                        Text('Makanan'),
                        Text('5 Km')
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 20.0,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.place, size: 48.0),
                        Text('Makanan'),
                        Text('5 Km')
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 20.0,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.place, size: 48.0),
                        Text('Makanan'),
                        Text('5 Km')
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 30.0),
            title: Text('Ulasan')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0),
            title: Text('Profile')
          )
        ],
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