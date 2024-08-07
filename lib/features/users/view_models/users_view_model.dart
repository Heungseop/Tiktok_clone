import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;
  // findProfile

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedin) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);

      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> craeteProfile(UserProfileModel profile) async {
    state = const AsyncValue.loading();
    _usersRepository.createProfile(profile); // profile 생성
    changeProfile(profile); // 로그인 유저정보 갱신
    state = AsyncValue.data(profile);
  }

  Future<void> changeProfile(UserProfileModel profile) async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(
      state.value!.uid,
      {"hasAvatar": true},
    );
  }

  Future<void> updateUserProfileRepository(Map<String, dynamic> map) async {
    await _usersRepository.updateUser(
      state.value!.uid,
      map,
    );
  }

// 로그인 후 로그인 유저 정보 저장
  void initLoginUser() async {
    if (_authenticationRepository.user == null) {
      return;
    }
    final user = _authenticationRepository.user!;
    // changeProfile(UserProfileModel.empty());

    Map<String, dynamic>? map = await _usersRepository.findProfile(user.uid);

    map ??= {
      "hasAvatar": false,
      "bio": "",
      "link": "",
      "birthday": "",
      "email": user.email ?? "",
      "uid": user.uid,
      "name": user.displayName ?? ""
    };
    changeProfile(UserProfileModel.fromJson(map));
  }

  Future<List<UserProfileModel>> fetchAllUsers() async {
    final result = await _usersRepository.listAllUsers();

    final users = result!.docs.map(
      (doc) => UserProfileModel.fromJson(doc.data()),
    );

    return users.toList();
  }

  Future<List<UserProfileModel>> fetchAllUsersNotMe() async {
    List<UserProfileModel> list = await fetchAllUsers();

    list.removeWhere(((element) => element.uid == state.value!.uid));
    return list;
  }

  Future<List<ChatRoomModel>> fetchMyChatRoomList() async {
    final result = await _usersRepository.fetchMyChatRoomList(state.value!.uid);
    final rooms = result!.docs.map(
      (doc) => ChatRoomModel.fromJson(doc.data()),
    );

    List<ChatRoomModel> list = rooms.toList();
    for (var room in list) {
      for (var uid in room.uidlist!) {
        room.users ??= [];
        UserProfileModel temp = UserProfileModel.fromJson(
            await _usersRepository.findProfile(uid) as Map<String, dynamic>);
        room.users!.add(temp);
      }
    }
    return list;
  }

  Future<UserProfileModel> findProfile(String uid) async {
    final profile = await _usersRepository.findProfile(uid);

    if (profile != null) {
      return UserProfileModel.fromJson(profile);
    }
    return UserProfileModel.empty();
  }

  // void addChatRoomListForUser(String roomId) async {
  //   print("@@@@ [uservm]addChatRoomListForUser")
  //   await _usersRepository.addUserChatRoomList(
  //       _authenticationRepository.user!.uid, roomId);
  // }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
    () => UsersViewModel());
