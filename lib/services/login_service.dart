import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:warungapp/data/endpoint.dart';

Future<bool> signIn(String email, String pass) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final url = BASE_URL_DEV+LOGIN;
  Map data = {
    'email': email,
    'password': pass
  };
  var jsonResponse = {};
  var response = await http.post(url, body: data);
  if(response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
    print('Response : $jsonResponse');
    if(jsonResponse != null) {
      sharedPreferences.setString("token", jsonResponse['result']['access_token']);
      return true;
    }
  } else {
    return false;
  }
}

Future<String> getToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final result = sharedPreferences.getString('token');
  print(result);
  return result;
}

Future<bool> checkExpired() async {    
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  if(token == null) {
    return false;
  }
  final url = BASE_URL_DEV+USER_DATA;
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  print(response.body);
  if(response.statusCode == 401) {
    print('Response ${response.body}');
    print('Expired token');
    return false;
  }
  return true;
}
