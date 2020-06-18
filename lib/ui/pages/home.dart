import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warungapp_mobile/ui/pages/login.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationPermission();
    checkLoginStatus();
  }

  checkLocationPermission() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    return geolocationStatus;
  }
  
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('url', 'http://192.168.85.82:8000');
    print(sharedPreferences.getString('token'));
    if(!(await checkExpired())) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
    }
    if(sharedPreferences.getString('token') == null ) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
    }
  }

  Future<bool> checkExpired() async {    
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    String url = sharedPreferences.getString('url')+'/api/auth/me';
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'
    });
    if(response.statusCode == 401) {
      print('Response ${response.body}');
      print('Expired token');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('WarungApp'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.menu)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                      Icon(Icons.favorite, size: 48.0, color: Colors.red),
                      SizedBox(height: 5),
                      Text('Favorit')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.place, size: 48.0, color: Colors.red[400]),
                      SizedBox(height: 5),
                      Text('Disekitar')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.dashboard,size: 48.0, color: Colors.green,),
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
                          text: 'Rekomendasi makanan',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey)
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Text('Lihat Semua >', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                        onTap: () {
                          Navigator.pushNamed(context, '/warungs/list');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 120,
              child: rekomendasiMakanan(context)
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
                          text: 'Rekomendasi warung',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey)
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Text('Lihat Semua >', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                        onTap: () {
                          Navigator.pushNamed(context, '/warungs/list');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: rekomendasiWarung(context),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0),
            title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 30.0),
            title: Text('Ulasan', style: TextStyle(fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0),
            title: Text('Profile',style: TextStyle(fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }


}

Widget rekomendasiMakanan(BuildContext context) {
  return ListView(
    shrinkWrap: true,
    padding: EdgeInsets.only(left: 20, right: 5),
    scrollDirection: Axis.horizontal,
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,                      
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset("assets/img/mie.jpg", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
            ),
            SizedBox(height: 5.0),                        
            Text('Mie Ayam'),
            Text('5 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset("assets/img/soto.jpg", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
            ),
            SizedBox(height: 5.0),
            Text('Soto Sutar'),
            Text('5 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,                      
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset("assets/img/pecel.jpg", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
            ),
            SizedBox(height: 5.0),
            Text('Pecel Emak'),
            Text('5 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: 20.0,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset("assets/img/nasi-rames.jpg", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
            ),
            Text('Ramesan'),
            Text('5 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
          ],
        ),
      ),
    ],
  );
}

Widget rekomendasiWarung(BuildContext context) {
  return ListView(
      padding: EdgeInsets.only(left: 20, right: 5),                
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,                      
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset("assets/img/logo-warung-makan-png-1.png", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
              ),
              SizedBox(height: 5.0),                        
              Text('Rumah Nasi Goreng'),
              Text('1.3 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset("assets/img/logo-warung-makan-png-6.png", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
              ),
              SizedBox(height: 5.0),
              Text('SEDERHANA'),
              Text('2 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,                      
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset("assets/img/logo-warung-makan-png-8.png", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
              ),
              SizedBox(height: 5.0),
              Text('LC Catering'),
              Text('4.1 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 20.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset("assets/img/logo-warung-makan-png-9.png", height: 60, width: 80, fit: BoxFit.cover, alignment: Alignment.center),
              ),
              Text('Depot Sentral'),
              Text('0.5 Km', style: TextStyle(fontSize: 15.0, color: Colors.grey))
            ],
          ),
        ),
      ],
    );
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