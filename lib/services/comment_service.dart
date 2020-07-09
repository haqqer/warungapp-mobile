import 'dart:convert';
import 'dart:io';

import 'package:warungapp/data/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:warungapp/models/Comment.dart';
import 'package:warungapp/services/login_service.dart';

Future<Map<String, dynamic>> postComment(Comment comment, List<File> imageFile) async {
  final url = BASE_URL_DEV+FOOD;
  final token = await getToken();
  Map data = {
    'warung_id': comment.warungId,
    'comment': comment,
    'score': comment.score
  };
  var jsonResponse = {};
  var response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  }, body: data);
  if(response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
    print('Response : $jsonResponse');
    if(jsonResponse != null) {
      return jsonResponse;
    }
  } else {
    return jsonResponse;
  }
}

Future<List<Comment>> getComments() async {
  final url = BASE_URL_DEV+FOOD;
  final token = await getToken();
  var jsonResponse = [];
  List<Comment> comments = List<Comment>();
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if(response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['result']['comments']['data'];
    if(jsonResponse != null) {
      comments = jsonResponse.map<Comment>((item) => Comment.fromJson(item)).toList();
      return comments;
    } else {
      print('error');
    }      
  } else {
    return comments;
  }    
}

