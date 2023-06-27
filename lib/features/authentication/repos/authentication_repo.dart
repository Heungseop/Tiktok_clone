import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // init하는 시점(await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);)
  // 부터 바로 인스턴스를 만들고 소통 가능해짐
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // user가 로그인됐는지 확인할게 아래 두개가 끝
  bool get isLoggedin => user != null;
  User? get user => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

// firebase 호출
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

final authRepo = Provider(
  (ref) => AuthenticationRepository(),
);

final authState = StreamProvider(
  (ref) {
    final repo = ref.read(authRepo);
    return repo.authStateChanges();
  },
);
