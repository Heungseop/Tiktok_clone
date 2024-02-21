import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc("d8giyYWbKCpM9KrscF8z")
        .collection("texts")
        .add(
          message.toJson(),
        );
  }

  Future<String> createChatRoom(List uidlist) async {
    String roomId = "";
    await _db.collection("chat_rooms").add({"uidlist": uidlist}).then((docRef) {
      // print("Document written with ID: ${docRef.id}");
      roomId = docRef.id;
    }).catchError((error) => print("Error adding document: $error"));

    return roomId;
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
