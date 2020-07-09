import 'dart:convert';
import 'dart:io';

import 'package:warungapp/data/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:warungapp/models/Food.dart';
import 'package:warungapp/services/login_service.dart';

Future<Map<String, dynamic>> postFood(Food food, List<File> imageFile) async {
  final url = BASE_URL_DEV+FOOD;
  final token = await getToken();
  var jsonResponse = {};
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers.addAll({
    'Authorization': 'Bearer $token'
  });
  request.fields['warung_id'] = food.warungId.toString();
  request.fields['description'] = food.description;
  request.fields['name'] = food.name;  
  request.fields['type'] = food.type;  
  request.fields['price'] = food.price.toString();
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

Future<List<Food>> getFoods() async {
  final url = BASE_URL_DEV+FOOD;
  final token = await getToken();
  var jsonResponse = [];
  List<Food> foods = List<Food>();
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if(response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['result']['foods']['data'];
    if(jsonResponse != null) {
      foods = jsonResponse.map<Food>((item) => Food.fromJson(item)).toList();
      return foods;
    } else {
      print('error');
    }      
  } else {
    return foods;
  }    
}

