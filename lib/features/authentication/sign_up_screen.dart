import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = "signUp";
  static const routeURL = "/";
  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) async {
    context.pushNamed(LoginScreen.routeName /**"/login" */);
    // go_route패키지가 context를 확장시켜줌(push)

    // context.go(LoginScreen.routeName);
    // page스택에 쌓이지 않음 0에서 다시 시작 (자동 백버튼 안생김, 이동한 화면에서 pop못씀)
  }

  void _onEmailTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("locale : ${Localizations.localeOf(context)}");
    return OrientationBuilder(
      builder: (context, orientation) {
        // orientation :  가로세로 여부 (portrait 세로, landscape 가로)
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
              child: Column(
                children: [
                  orientation == Orientation.portrait ? Gaps.v80 : Gaps.v40,
                  Text(
                    // Date format!!!!!!!
                    // https://api.flutter.dev/flutter/intl/DateFormat-class.html
                    S.of(context).signUpTitle("TikTok", DateTime.now()),
                    style: const TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w600,
                    ),
                    // style: GoogleFonts.abrilFatface(
                    //   textStyle: const TextStyle(
                    //     fontSize: Sizes.size24,
                    //   ),
                    // ),
                    // style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    //       // color: Theme.of(context).primaryColor,
                    //       fontWeight: FontWeight.w600,
                    //     ), // 지정 테마에 특정 요소를 추가하려면 copyWith사용
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: .7,
                    child: Text(
                      S.of(context).signUpSubTitle(2),
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  if (orientation == Orientation.portrait) ...[
                    AuthButton(
                      onTap: _onEmailTap,
                      icon: const FaIcon(FontAwesomeIcons.user),
                      text: S.of(context).emailPasswordButton,
                    ),
                    Gaps.v16,
                    AuthButton(
                      // onTap: () => {},
                      icon: const FaIcon(FontAwesomeIcons.apple),
                      text: S.of(context).appleButton,
                    )
                  ],
                  // 가로모드를 고려해 로우로 감쌀 경우 아래 authButton이 FractionallySizedBox이기때문에 width가 지정되지 않아
                  // 에러난다 (FractionallySizedBox = 가능한 최대한의 크기 이지만 부모인 로우는 크기를 지정해주지않고 infinity이다 )
                  // Expanded로 감싸면 해결된다.
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: AuthButton(
                            onTap: _onEmailTap,
                            icon: const FaIcon(FontAwesomeIcons.user),
                            text: S.of(context).emailPasswordButton,
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            // onTap: () => {},
                            icon: const FaIcon(FontAwesomeIcons.apple),
                            text: S.of(context).appleButton,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDarkMode(context)
                ? null
                : Colors.grey.shade50, //null>테마를 따른다.
            // elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).alreadyHaveAnAccount,
                    style: const TextStyle(),
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      S.of(context).logIn,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
