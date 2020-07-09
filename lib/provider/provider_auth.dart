import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderAuth extends ChangeNotifier {
  String _url = 'http://192.168.85.85:8000';
  String _token = '';
  LatLng _position;
  String _address;

  String get getUrl => _url;
  String get getToken => _token;
  LatLng get getPosition => _position;
  String get getAddress => _address;

  void setPosition(LatLng position) {
    _position = position;
    notifyListeners();
  }
  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
  set setToken(String token) {
    _token = token;
    notifyListeners();
  }

}