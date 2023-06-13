import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';
  }
}

void main() async {
  // 앱 실행전에 어떤 코드를 실행 시키기 위해(앱 시작전 state를 어떤 식으로든 바꾸고 싶다면)
  // 아래와같이 엔진:위젯의 연결을 바인딩, 초기화 해주어야한다.
  // 오직 runApp을 실행하기 전에 바인딩을 초기화할 때만 호출해야 한다.
  WidgetsFlutterBinding.ensureInitialized();

  // 앱의 세로고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 상태바 텍스트 컬러
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  HttpOverrides.global = MyHttpOverrides();
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        theme: ThemeData(
          primaryColor: const Color(0xffe9435a),
          scaffoldBackgroundColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            // cupertino search input 의 커서컬러는 수정이 안되지만 테마에서 전체적인 커서컬러를 지정할 수 있음
            cursorColor: Color(0xffe9435a),
            // selectionColor: Color(0xffe9435a),
          ),
          splashColor: Colors.transparent, // 버튼을 누르고 있으면 어두운 배경이 점점 퍼지는 효과 제거
          // highlightColor: Colors.transparent, // 버튼을 누르고 있으면 배경이 어두워지는 효과 제거
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        home: const MainNavigationScreen());
  }
}
