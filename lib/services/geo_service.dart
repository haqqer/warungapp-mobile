import 'package:geolocator/geolocator.dart';

Future<void> checkLocationPermission() async {
  GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final myLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  print('geolocation');
  print(geolocationStatus.value);
  print(myLocation);
}

Future<Position> getMyLocation() async {
  GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final myLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  return myLocation;
}