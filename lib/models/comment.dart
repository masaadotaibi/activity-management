class Comment {
  String commentId;
  String commentText;
  DateTime time;

  Comment({this.commentId, this.commentText, this.time});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    commentText = json['commentText'];
    time = DateTime.fromMicrosecondsSinceEpoch(
        json['time'].microsecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['commentText'] = this.commentText;
    data['time'] = this.time;
    return data;
  }
}
