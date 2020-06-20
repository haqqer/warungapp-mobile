import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pembangunan/models/Pembangunan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pembangunan/ui/pages/login.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  List<Pembangunan> pembangunans = List();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationPermission();
    checkLoginStatus();
    getDataPembangunan();
  }

  checkLocationPermission() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    final myLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('geolocation');
    print(geolocationStatus.value);
    print(myLocation);
  }
  
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('url', 'http://192.168.1.38:8000');
    print(sharedPreferences.getString('token'));
    if(!(await checkExpired())) {
      print('expired');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
    }
    if(sharedPreferences.getString('token') == null ) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
    }
  }

  logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    await sharedPreferences.setString('url', 'http://192.168.1.38:8000');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
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

  getDataPembangunan() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    String url = sharedPreferences.getString('url')+'/api/pembangunan';
    String token = sharedPreferences.getString('token');
    var jsonResponse = [];
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'
    });
    if(response.statusCode == 200) {
      // jsonResponse = json.decode(response.body)['result']['pembangunans']['data'];
      jsonResponse = json.decode(response.body)['result']['pembangunans']['data'];
      print(jsonResponse);
      if(jsonResponse != null) {
        pembangunans = jsonResponse.map<Pembangunan>((item) => Pembangunan.fromJson(item)).toList();
        setState(() {
        _isLoading = false;
      });
      } else {
        print('error');
      }      
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
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
                  logout();
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
          backgroundColor: Colors.red,
          elevation: 0,
          title: Text('Pembangunan'),
          actions: <Widget>[
            // RaisedButton(
            //   color: Colors.red,
            //   child: Icon(Icons.delete, color: Colors.white),
            //   onPressed: () {
            //     logout();
            //   },
            // )
            IconButton(
              onPressed: () {
                getDataPembangunan();
              },
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pembangunans.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(pembangunans[index].keterangan), 
                          subtitle: pembangunans[index].pilihan != 0 ? Text('Ya') : Text('Tidak'),
                          onTap: () {

                          },
                          trailing: Icon(Icons.menu),
                        )
                      );
                    },
                  ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/pembangunan/create');
          },
          child: Icon(Icons.add),
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