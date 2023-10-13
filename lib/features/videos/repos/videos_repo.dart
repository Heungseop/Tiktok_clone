import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload  a video
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  // create a video document
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      {int? lastItemCreatedAt}) {
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);

    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    // like 한유저인지 찾는 작업이 firebase에선 매우 비싼 작업이 될 수 있기때문에 다른 접근이 필요함
    // await _db
    //     .collection("likes")
    //     .where("videoId", isEqualTo: videoId)
    //     .where("userId", isEqualTo: userId);

    // 특정아이디로 도큐먼트를 만들어 저장하고 찾는다 Id를 찾는건 빠른가봄
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();

    if (!like.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await query.delete();
    }
  }

  //좋아요한 video인지 확인한다.
  Future<bool> isLikeVideo(String videoId, String userId) async {
    // 특정아이디로 도큐먼트를 만들어 저장하고 찾는다 Id를 찾는건 빠른가봄
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();
    return like.exists;
  }
}

final videosRepo = Provider((ref) {
  return VideosRepository();
});
