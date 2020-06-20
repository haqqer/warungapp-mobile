import 'package:pembangunan/models/Photo.dart';

class Pembangunan {
  int id;
  int userId;
  int pilihan;
  String keterangan;
  String coordinat;
  List<Photo> photos;
  
  Pembangunan({this.id, this.userId, this.pilihan, this.keterangan, this.coordinat, this.photos});

  Pembangunan.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      pilihan = json['pilihan'],
      keterangan = json['keterangan'],
      coordinat = json['coordinat'],
      photos = parsePhotos(json['photos']);
      
  static List<Photo> parsePhotos(List<dynamic> items) {
    return items.map<Photo>((item) => Photo.fromJson(item)).toList();
  }
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'pilihan': pilihan,
    'keterangan': keterangan,
    'coordinat': coordinat,
  };
}