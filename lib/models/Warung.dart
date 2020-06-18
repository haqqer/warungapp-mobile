class Warung {
  int id;
  int userId;
  String name;
  String description;
  String address;
  int status;
  double latitude;
  double longitude;
  List<dynamic> photos;
  
  Warung({this.id, this.userId, this.name, this.description, this.address, this.status, this.latitude, this.longitude, this.photos});

  Warung.fromJSon(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      name = json['name'],
      description = json['description'],
      address = json['address'],
      status = int.parse(json['status']),
      latitude = json['latitude'],
      longitude = json['longitude'],
      photos = json['photos'];

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'description': description,
    'address': address,
    'status': status,
    'latitude': latitude,
    'longitude': longitude,
  };
}