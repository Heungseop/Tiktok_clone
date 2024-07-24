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

  int lastMsgDate;
  String lastMsg;

  ChatRoomModel({
    required this.roomId,
    this.text,
    this.createUserId,
    this.uidlist,
    this.users,
    this.ref,
    required this.lastMsgDate,
    required this.lastMsg,
  });

  // ChatRoomModel.empty()
  //     : roomId = "",
  //       text = [],
  //       createUserId = "",
  //       uidlist = [],
  //       users = [],
  //       ref = null,
  //       lastMsgDate = ,
  //       lastMsg = "";

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        text = json['text'],
        createUserId = json['createUserId'],
        uidlist = json['uidlist'],
        lastMsgDate = json['lastMsgDate'],
        lastMsg = json['lastMsg'];

  Map<String, dynamic> toJson() {
    return ({
      "roomId": roomId,
      "text": text,
      "createUserId": createUserId,
      "uidlist": uidlist,
      "lastMsgDate": lastMsgDate,
      "lastMsg": lastMsg,
    });
  }

  void syncUserProfileModel({WidgetRef? ref}) async {
    print("######### syncUserProfileModel uidlist : $uidlist, ref : $ref");
    if (uidlist != null) {
      for (String uid in uidlist!) {
        print("######### syncUserProfileModel uid : $uid");
        UserProfileModel temp =
            await ref!.read(usersProvider.notifier).findProfile(uid);
        print("######### temp(UserProfileModel): ${temp.toString()}");
        users?.add(temp);
      }
    }
  }

  List<UserProfileModel> getUserListExMe(String excludeUid) {
    final userListExMe = [...?users];
    userListExMe.removeWhere((element) => element.uid == excludeUid);
    return userListExMe;
  }

  @override
  String toString() {
    return "roomId : [$roomId], text : [$text], createUserId : [$createUserId], uidlist : [$uidlist], users : [$users], lastMsgDate : [$lastMsgDate], lastMsg : [$lastMsg]";
  }
}
