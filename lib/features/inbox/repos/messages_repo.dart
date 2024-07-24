import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc(message.roomId)
        .collection("texts")
        .add(
          message.toJson(),
        )
        .then((docRef) {
      docRef.update({"messageId": docRef.id});
    });

    await _db.collection("chat_rooms").doc(message.roomId).update({
      "lastMsgDate": message.createdAt,
      "lastMsg": message.text,
    });
  }

  Future<void> deleteMessage(MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc(message.roomId)
        .collection("texts")
        .doc(message.messageId)
        .update({"text": "[deleted]"});

    await _db.collection("chat_rooms").doc(message.roomId).update({
      "lastMsg": "[deleted]",
    });
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
