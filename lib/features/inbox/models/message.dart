class MessageModel {
  final String text;
  final String userId;
  final int createdAt;
  final String roomId;

  MessageModel({
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.roomId,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        userId = json['userId'],
        createdAt = json['createdAt'],
        roomId = json['roomId'];

  Map<String, dynamic> toJson() {
    return ({
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
      "roomId": roomId,
    });
  }
}
