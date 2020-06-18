import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:warungapp_mobile/models/Warung.dart';

class ListWarungPage extends StatefulWidget {
  @override
  _ListWarungPageState createState() => _ListWarungPageState();
}

class _ListWarungPageState extends State<ListWarungPage> {
  SharedPreferences sharedPreferences;
  List<Warung> warungs;
  Position _position;
  @override
  void initState() { 
    super.initState();
    getCurrentLocation();
    getWarungs();
  }


  getWarungs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    String url = sharedPreferences.getString('url')+'/api/warungs';
    List jsonResponse;
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'
    });
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body)['result']['warungs']['data'];
      print(jsonResponse);
      print('Response : $jsonResponse');
      if(jsonResponse != null) {
        warungs = jsonResponse.map((item) => Warung.fromJSon(item)).toList();
        print(warungs);
      } else {
        print('error');
      }
    }
  }

  getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    final myLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _position = myLocation;
    });
    print(_position);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Warung'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _position != null ? LatLng(-6.9848413,110.4158489) : LatLng(_position.latitude, _position.longitude),
          zoom: 14.0
        ),
      )
    );
  }
}