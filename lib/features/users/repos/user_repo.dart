import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create
  Future<void> createProfile(UserProfileModel user) async {
    // _db.
  }
  // get
  // update
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
