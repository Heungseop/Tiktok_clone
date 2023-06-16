import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

import 'constants/sizes.dart';

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
    // S.load(const Locale("en"));
    const primaryColor = Color(0xffe9435a);
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        // S().delegate,
      ],
      supportedLocales: const [Locale("en"), Locale("ko")],
      // 언어 코드 확인
      // https://api.flutter.dev/flutter/dart-ui/Locale/languageCode.html
      // https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry

      // 15.9 Conclusions 추후엔 테마패키지를 사용하자.... 두줄이면 끝..
      // theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      // // The Mandy red, dark theme.
      // darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: Typography
            .blackMountainView, // Typography > geometry (font size, weight, etc) 정보 없이 컬러와 폰트(?)만 제공
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade50),
        textSelectionTheme: const TextSelectionThemeData(
          // cupertino search input 의 커서컬러는 수정이 안되지만 테마에서 전체적인 커서컬러를 지정할 수 있음
          cursorColor: primaryColor,
          // selectionColor: primaryColor,
        ),
        splashColor: Colors.transparent, // 버튼을 누르고 있으면 어두운 배경이 점점 퍼지는 효과 제거
        // highlightColor: Colors.transparent, // 버튼을 누르고 있으면 배경이 어두워지는 효과 제거
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        listTileTheme: const ListTileThemeData(iconColor: Colors.black),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: Colors.black,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: primaryColor,
        brightness: Brightness.dark,
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade900),
        textTheme: Typography.whiteMountainView,
        // appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: primaryColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade700,
          indicatorColor: Colors.white,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      // home: const SignUpScreen(),
    );
  }
}

// class LayoutBuilderCodeLab extends StatelessWidget {
//   const LayoutBuilderCodeLab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SizedBox(
//         width: size.width / 2,
//         child: LayoutBuilder(
//           // LayoutBuilder가 차지할 수 있는 공간의 크기를 알려준다. MediaQuery와는 명확하게 다름.
//           builder: (context, constraints) {
//             return Container(
//               width: constraints.maxWidth,
//               height: constraints.maxHeight,
//               color: Colors.teal,
//               child: Center(
//                 child: Text(
//                   "${size.width}/${constraints.maxWidth}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: Sizes.size24,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
