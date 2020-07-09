class Photo {
  int id;
  int userId;
  int warungId;
  String path;
  
  Photo({this.id, this.userId, this.warungId, this.path});

  Photo.fromJson(Map<String, dynamic> json)
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