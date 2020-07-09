import 'dart:convert';
import 'dart:io';

import 'package:warungapp/data/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/services/login_service.dart';

Future<Map<String, dynamic>> postWarung(Warung warung, List<File> imageFile) async {
  final url = BASE_URL_DEV+WARUNG;
  final token = await getToken();
  var jsonResponse = {};
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers.addAll({
    'Authorization': 'Bearer $token'
  });
  request.fields['name'] = warung.name;
  request.fields['description'] = warung.description;
  request.fields['address'] = warung.address;  
  request.fields['status'] = '1';
  request.fields['latitude'] = warung.latitude.toString();
  request.fields['longitude'] = warung.longitude.toString();
  request.files.add(await http.MultipartFile.fromPath('image', imageFile[0].path));
  // for(var i=0; i<imageFile.length; i++) {
  //   print('image_$i');
  //   request.files.add(await http.MultipartFile.fromPath('image_$i', imageFile[i].path));
  // }
  var response = await request.send();
  var responseParsed = await http.Response.fromStream(response);  
  print(responseParsed.body);
  if(response.statusCode == 201) {
    jsonResponse = json.decode(responseParsed.body)['result'];
    print('Response : ${jsonResponse}');
    print(jsonResponse['id']);
    if(jsonResponse != null) {
      return jsonResponse;
    }
  } else {
    print(responseParsed);
    return {'error': true};
  }  
}

Future<List<Warung>> getWarungs() async {
  final url = BASE_URL_DEV+WARUNG;
  final token = await getToken();
  var jsonResponse = [];
  List<Warung> warungs = List<Warung>();
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if(response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['result']['warungs']['data'];
    if(jsonResponse != null) {
      warungs = jsonResponse.map<Warung>((item) => Warung.fromJson(item)).toList();
      return warungs;
    } else {
      print('error');
    }      
  } else {
    return warungs;
  }    
}

Future<Warung> getWarungById(int warungId) async {
  final url = BASE_URL_DEV+WARUNG+'/'+warungId.toString();
  final token = await getToken();
  var jsonResponse = {};
  Warung warung = Warung();
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if(response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['result'];
    if(jsonResponse != null) {
      warung = Warung.fromJson(jsonResponse);
      return warung;
    } else {
      print('error');
    }      
  } else {
    return warung;
  }    
}

