import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createChatRoom(List uidlist) async {
    String roomId = "";
    await _db.collection("chat_rooms").add({"uidlist": uidlist}).then((docRef) {
      roomId = docRef.id;
      docRef.update({
        "roomId": roomId,
        "lastMsgDate": DateTime.now().millisecondsSinceEpoch,
        "lastMsg": "",
      });
    }).catchError((error) => print("Error adding document: $error"));

    return roomId;
  }

  // get
  Future<Map<String, dynamic>?> getChatRoom(String roomId) async {
    final doc = await _db.collection("chat_rooms").doc(roomId).get();
    return doc.data();
  }

  // // create
  // Future<void> createProfile(UserProfileModel profile) async {
  //   await _db.collection("users").doc(profile.uid).set(profile.toJson());
  // }

  // // get
  // Future<Map<String, dynamic>?> findProfile(String uid) async {
  //   final doc = await _db.collection("users").doc(uid).get();
  //   return doc.data();
  // }

  // // update
  // Future<void> uploadAvatar(File file, String fileName) async {
  //   final fileRef = _storage
  //       .ref()
  //       .child("avatars/$fileName"); // 아직 업로드된 것은 아니고 단지 공간을 만드는 것
  //   await fileRef.putFile(file);
  // }

  // Future<void> updateUser(String uid, Map<String, dynamic> data) async {
  //   await _db.collection("users").doc(uid).update(data);
  // }

  // // get
  // Future<QuerySnapshot<Map<String, dynamic>>?> listAllUsers() async {
  //   return _db.collection("users").orderBy("email").get();
  // }

  // Future<void> addUserChatRoomList(String roomId, List<String> uidlist) async {
  //   for (String uid in uidlist) {
  //     await _db
  //         .collection("users")
  //         .doc(uid)
  //         .collection("chat_room_list")
  //         .doc(roomId)
  //         .set({
  //       "roomId": roomId,
  //       "uidlist": uidlist,
  //       "lastMsgDate": DateTime.now().millisecondsSinceEpoch,
  //       "lastMsg": "",
  //     });
  //   }
  // }

  // // get
  // Future<QuerySnapshot<Map<String, dynamic>>?> fetchMyChatRoomList(
  //     String uid) async {
  //   final doc = _db.collection("users").doc(uid).collection("chat_room_list");
  //   return doc.get();
  // }
}

final ChatRoomRepo = Provider(
  (ref) => ChatRoomRepository(),
);
