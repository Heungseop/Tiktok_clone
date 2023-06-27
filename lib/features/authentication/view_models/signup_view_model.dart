import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_vieew_model.dart';
import 'package:tiktok_clone/utils.dart';

//계정 생성 시 로딩화면을 보여주고 계정생성을 트리거 할 뿐이라 expose할 데이터가 없음.
class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);

    state = await AsyncValue.guard(
        // error state 처리해줌
        () async {
      final userCredentioal = await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      );

      if (userCredentioal.user == null) {
        throw Exception("Account not created");
      }

      final profile = UserProfileModel(
        bio: "undefined",
        link: "undefined",
        birthday: form["birthday"],
        email: userCredentioal.user!.email ?? "anon@anon.com",
        uid: userCredentioal.user!.uid,
        name: form["username"],
      );

      await users.craeteProfile(profile);
    });

    if (state.hasError) {
      showFirebaseError(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

//유저가 양식을 채우면서 채워나갈 form정보(map => {})
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
