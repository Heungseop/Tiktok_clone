class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumnailUrl;
  final String createUid;
  final String creator;
  final int likes;
  final int comments;
  final int createdAt;

  VideoModel({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumnailUrl,
    required this.createUid,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.creator,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumnailUrl": thumnailUrl,
      "createUid": createUid,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
      "creator": creator,
    };
  }
}
