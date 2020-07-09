class Food {
  int id;
  int userId;
  int warungId;
  String name;
  String description;
  String type;
  int price;
  List<FoodPhoto> photos;
  
  Food({this.id, this.userId, this.warungId, this.name, this.description, this.price, this.type, this.photos});

  Food.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      warungId = json['warung_id'],
      name = json['name'],
      description = json['description'],
      type = json['type'],
      price = json['price'],
      photos = parsePhotos(json['photos']);
      
  static List<FoodPhoto> parsePhotos(List<dynamic> items) {
    return items.map<FoodPhoto>((item) => FoodPhoto.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'warung_id': warungId,
    'name': name,
    'description': description,
    'type': type,
    'price': price,
  };
}

class FoodPhoto {
  int id;
  int userId;
  int foodId;
  String path;
  
  FoodPhoto({this.id, this.userId, this.foodId, this.path});

  FoodPhoto.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      foodId = json['food_id'],
      path = json['path'];

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'food_id': foodId,
    'path': path
  };  
}