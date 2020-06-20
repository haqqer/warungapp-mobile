class Photo {
  int id;
  int userId;
  int pembangunanId;
  String path;
  
  Photo({this.id, this.userId, this.pembangunanId, this.path});

  Photo.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      pembangunanId = json['pembangunan_id'],
      path = json['path'];

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'pembangunan_id': pembangunanId,
    'path': path
  };
}