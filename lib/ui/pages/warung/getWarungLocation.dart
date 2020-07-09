import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:warungapp/provider/provider_auth.dart';
import 'package:warungapp/services/geo_service.dart';
class GetWarungLocationPage extends StatefulWidget {
  @override
  _GetWarungLocationPageState createState() => _GetWarungLocationPageState();
}

class _GetWarungLocationPageState extends State<GetWarungLocationPage> {
  Position currentPosition;
  String nameLocation = '';
  Set<Marker> _markers = Set<Marker>();
  ProviderAuth state;

  getCurrentLocation() async {
    final myLocation = await getMyLocation();
    setState(() {
      currentPosition = myLocation;
    });
  }

  setMarker() async {
    _markers.add(Marker(
      markerId: MarkerId('warung_location'),
      position: LatLng(currentPosition.latitude, currentPosition.longitude)
    ));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    setMarker();
  }

  getNameLocation(LatLng position) async {
    final coordinates = Coordinates(position.latitude, position.longitude);
    final address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      nameLocation = address.first.addressLine;
    });
  }
  @override
  Widget build(BuildContext context) {
    state = Provider.of<ProviderAuth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Warung'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: currentPosition != null ?  LatLng(currentPosition.latitude, currentPosition.longitude) : LatLng(-6.9859062, 110.414304),
                  zoom: 15
                ),
                markers: _markers,
                onTap: (position) {
                  getNameLocation(position);
                  setState(() {
                    _markers.removeWhere((m) => m.markerId.value == 'warung_location');
                    currentPosition = Position(latitude: position.latitude, longitude: position.longitude);
                    _markers.add(Marker(
                      markerId: MarkerId('warung_location'),
                      position: LatLng(currentPosition.latitude, currentPosition.longitude),
                      infoWindow: InfoWindow(
                        title: nameLocation
                      )
                    ));                    
                  });
                },
              ),                
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          state.setPosition(LatLng(currentPosition.latitude, currentPosition.longitude));
          state.setAddress(nameLocation);
          Navigator.pushNamed(context, '/warung/create');
        },
        child: Icon(Icons.check),
      ),
    );
  }
}