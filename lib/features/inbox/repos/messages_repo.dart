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
        );

    await _db.collection("chat_rooms").doc(message.roomId).update({"": ""});
  }

  Future<String> createChatRoom(List uidlist) async {
    String roomId = "";
    await _db.collection("chat_rooms").add({"uidlist": uidlist}).then((docRef) {
      roomId = docRef.id;
      docRef.update({"roomId": roomId});
    }).catchError((error) => print("Error adding document: $error"));

    return roomId;
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
