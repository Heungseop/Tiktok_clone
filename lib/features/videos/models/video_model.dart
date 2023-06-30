class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumnailUrl;
  final String createUid;
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
  });
}
