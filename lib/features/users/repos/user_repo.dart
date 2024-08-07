import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // create
  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // get
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // update
  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage
        .ref()
        .child("avatars/$fileName"); // 아직 업로드된 것은 아니고 단지 공간을 만드는 것
    await fileRef.putFile(file);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // get
  Future<QuerySnapshot<Map<String, dynamic>>?> listAllUsers() async {
    return _db.collection("users").orderBy("email").get();
  }

  Future<void> addUserChatRoomList(String roomId, List<String> uidlist) async {
    for (String uid in uidlist) {
      await _db
          .collection("users")
          .doc(uid)
          .collection("chat_room_list")
          .doc(roomId)
          .set({
        "roomId": roomId,
        "uidlist": uidlist,
        "lastMsgDate": DateTime.now().millisecondsSinceEpoch,
        "lastMsg": "",
      });
    }
  }

  // get
  Future<QuerySnapshot<Map<String, dynamic>>?> fetchMyChatRoomList(
      String uid) async {
    final doc = _db.collection("users").doc(uid).collection("chat_room_list");
    return doc.get();
  }
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
