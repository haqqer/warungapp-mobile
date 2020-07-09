class Comment {
  int id;
  int userId;
  int warungId;
  String comment;
  int score;
  
  Comment({this.id, this.userId, this.warungId, this.comment, this.score});

  Comment.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['user_id'],
      warungId = json['warung_id'],
      comment = json['comment'],
      score = json['score'];
      
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'warung_id': warungId,
    'comment': comment,
    'score': score
  };
}


