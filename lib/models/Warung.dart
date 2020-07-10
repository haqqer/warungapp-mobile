import 'package:warungapp/models/Comment.dart';
import 'package:warungapp/models/Food.dart';

class Warung {
  int id;
  int userId;
  String name;
  String description;
  String address;
  double latitude;
  double longitude;
  double average;
  List<WarungPhoto> photos;
  List<Food> foods;
  List<Comment> comments;
  
  Warung({this.id, this.userId, this.name, this.description, this.address,  this.latitude, this.longitude, this.photos, this.foods, this.comments, this.average});

  Warung.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      name = json['name'],
      description = json['description'],
      address = json['address'],
      latitude = json['latitude'],
      longitude = json['longitude'],
      average = json['average'] != null ? double.parse(json['average']) : null,
      photos = parsePhotos(json['photos']),
      foods = parseFoods(json['foods']),
      comments = parseComments(json['comments']);
      
  static List<WarungPhoto> parsePhotos(List<dynamic> items) {
    return items.map<WarungPhoto>((item) => WarungPhoto.fromJson(item)).toList();
  }

  static List<Food> parseFoods(List<dynamic> items) {
    return items.map<Food>((item) => Food.fromJson(item)).toList();
  }

  static List<Comment> parseComments(List<dynamic> items) {
    return items.map<Comment>((item) => Comment.fromJson(item)).toList();
  }
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'description': description,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class WarungPhoto {
  int id;
  int userId;
  int warungId;
  String path;
  
  WarungPhoto({this.id, this.userId, this.warungId, this.path});

  WarungPhoto.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      warungId = json['warung_id'],
      path = json['path'];

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'warung_id': warungId,
    'path': path
  };  
}