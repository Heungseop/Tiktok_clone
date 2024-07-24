// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBdcS8nzORBv_-H7cDOPNkmjyDQihxomgA',
    appId: '1:451104750719:web:24e7eec11ae0bc9194934a',
    messagingSenderId: '451104750719',
    projectId: 'tiktok-clone-heungg',
    authDomain: 'tiktok-clone-heungg.firebaseapp.com',
    storageBucket: 'tiktok-clone-heungg.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4iZ8a9sgnNTIC1-txhGycT96bR1L4nn0',
    appId: '1:451104750719:android:3685c3ed8f66ae2894934a',
    messagingSenderId: '451104750719',
    projectId: 'tiktok-clone-heungg',
    storageBucket: 'tiktok-clone-heungg.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwMhEFGLTVYrooJy23rQBaCVZfOGcb7Yo',
    appId: '1:451104750719:ios:5421dfa29e86a9fe94934a',
    messagingSenderId: '451104750719',
    projectId: 'tiktok-clone-heungg',
    storageBucket: 'tiktok-clone-heungg.appspot.com',
    androidClientId: '451104750719-skev21340i7k8v9uo6aaohga0l35aqs9.apps.googleusercontent.com',
    iosClientId: '451104750719-6b5ker6khdrtorbsrjls06931eqt3j1e.apps.googleusercontent.com',
    iosBundleId: 'com.huengg.tiktokClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwMhEFGLTVYrooJy23rQBaCVZfOGcb7Yo',
    appId: '1:451104750719:ios:590c8d16f2be840694934a',
    messagingSenderId: '451104750719',
    projectId: 'tiktok-clone-heungg',
    storageBucket: 'tiktok-clone-heungg.appspot.com',
    androidClientId: '451104750719-skev21340i7k8v9uo6aaohga0l35aqs9.apps.googleusercontent.com',
    iosClientId: '451104750719-cfhi9cu25q9gpaut1qq6b5m2akbsu5fq.apps.googleusercontent.com',
    iosBundleId: 'com.example.tiktokClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdcS8nzORBv_-H7cDOPNkmjyDQihxomgA',
    appId: '1:451104750719:web:fa070edc16aead3c94934a',
    messagingSenderId: '451104750719',
    projectId: 'tiktok-clone-heungg',
    authDomain: 'tiktok-clone-heungg.firebaseapp.com',
    storageBucket: 'tiktok-clone-heungg.appspot.com',
  );

}