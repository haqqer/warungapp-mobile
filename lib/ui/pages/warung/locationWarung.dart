import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/data/endpoint.dart';
import 'package:warungapp/services/geo_service.dart';
import 'package:warungapp/services/warung_service.dart';
import 'package:warungapp/ui/pages/warung/getWarung.dart';

class LocationWarungPage extends StatefulWidget {
  @override
  _LocationWarungPageState createState() => _LocationWarungPageState();
}

class _LocationWarungPageState extends State<LocationWarungPage> {
  bool _isLoading = false;
  List<Warung> _warungs = [];
  Set<Marker> _markers = Set<Marker>();
  Position currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    getDataWarungs();
    setMarker();
  }

  // getNameLocation(LatLng position) async {
  //   final coordinates = Coordinates(position.latitude, position.longitude);
  //   final address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   setState(() {
  //     nameLocation = address.first.addressLine;
  //   });
  // }

  getCurrentLocation() async {
    final myLocation = await getMyLocation();
    setState(() {
      currentPosition = myLocation;
    });
  }

  setMarker() async {
    print('jalan');
    for(var item in _warungs) {
      print(item.name);
    }
    // _warungs.map((item) {
    //   _markers.add(Marker(
    //     markerId: MarkerId(item.id.toString()),
    //     position: LatLng(item.latitude, item.longitude)
    //   ));
    // });
    // setState(() {

    //   });
  }

  getDataWarungs() async {
    setState(() {
      _isLoading = true;
    });    
    final result = await getWarungsAll();
    setState(() {
      _warungs = result;
      _warungs.forEach((item) { 
        _markers.add(Marker(
          markerId: MarkerId(item.id.toString()),
          infoWindow: InfoWindow(
            title: item.name
          ),
          position: LatLng(item.latitude, item.longitude)
        ));
      });
    });
  }  
  @override
  Widget build(BuildContext context) {
    // state = Provider.of<ProviderAuth>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: currentPosition != null ?  LatLng(currentPosition.latitude, currentPosition.longitude) : LatLng(-6.9859062, 110.414304),
                        zoom: 15
                      ),
                      markers: _markers,
                      onTap: (position) {
                        // getNameLocation(position);
                        // setState(() {
                        //   _markers.removeWhere((m) => m.markerId.value == 'warung_location');
                        //   currentPosition = Position(latitude: position.latitude, longitude: position.longitude);
                        //   _markers.add(Marker(
                        //     markerId: MarkerId('warung_location'),
                        //     position: LatLng(currentPosition.latitude, currentPosition.longitude),
                        //   ));                    
                        // });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RaisedButton(
                        child: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 30),
                        shape: CircleBorder(),
                        color: Colors.white,
                        disabledElevation: 0,
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: _warungs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetWarungPage(warungId: _warungs[index].id)), (route) => false);
                      },
                      child: Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: _warungs[index].photos.length > 0  ? Image.network(
                                  UPLOAD+'/'+_warungs[index].photos[0].path,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  height: MediaQuery.of(context).size.width * 0.2,
                                  fit: BoxFit.fill, alignment: FractionalOffset.center
                                ) : Icon(Icons.camera_alt, size: MediaQuery.of(context).size.width * 0.2),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_warungs[index].name, style: Theme.of(context).textTheme.subtitle2),
                                    SizedBox(height: 8),
                                    Text(_warungs[index].description, style: Theme.of(context).textTheme.bodyText2),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}