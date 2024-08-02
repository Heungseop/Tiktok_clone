import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  // 초기화되는 걸 보장한다.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //1단계
  // 실제 구동되는것처럼 초기화 해줘야함
  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // 로그아웃상태에서 시작
    await FirebaseAuth.instance.signOut();
  });

  testWidgets("Craete Account Flow", (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: TikTokApp(),
    ));

    // 애니메이션 효과/화면전환 등으로 나오는 프레임은 넘어가고 화면의 최종 프레임을 렌더링한다.
    await tester.pumpAndSettle();

    expect(find.text("Sign up for TikTok"), findsOneWidget);
    expect(find.text("Log in"), findsOneWidget);

    //다른화면 발생
    await tester.tap(find.text("Log in"));
    await tester.pumpAndSettle();

    // login screen-------------------------------------------------------------------------------------------
    final singUp = find.text("Sign Up");
    expect(singUp, findsOneWidget);
    await tester.tap(singUp);
    await tester.pumpAndSettle();

    final emailBtn = find.text("Use Email & Password");
    expect(emailBtn, findsOneWidget);
    await tester.tap(emailBtn);
    await tester.pumpAndSettle();

    final usernameInput = find.byType(TextField).first;
    await tester.enterText(usernameInput, "test");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();

    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, "test@testing.com");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();

    final passwordInput = find.byType(TextField).first;
    await tester.enterText(passwordInput, "1q2w3e4r5t!");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });

  //2단계
  // tearDown = 테스트가 완료된 다음에 돌아가는 함수
  // tearDown(
  //   () => null,
  // );

  //3단계
}
