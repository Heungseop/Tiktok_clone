import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatRoomModel {
  final String roomId;
  List<String>? text;
  String? createUserId;
  List<dynamic>? uidlist;
  List<UserProfileModel>? users;
  WidgetRef? ref;

  ChatRoomModel({
    required this.roomId,
    this.text,
    this.createUserId,
    this.uidlist,
    this.users,
    this.ref,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        text = json['text'],
        createUserId = json['createUserId'],
        uidlist = json['uidlist'];

  Map<String, dynamic> toJson() {
    return ({
      "roomId": roomId,
      "text": text,
      "createUserId": createUserId,
      "uidlist": uidlist,
    });
  }

  void syncUserProfileModel() {
    if (uidlist != null && ref != null) {
      for (String uid in uidlist!) {
        ref!.read(usersProvider.notifier).findProfile(uid);
      }
    }
  }
}
