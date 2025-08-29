import 'package:flutter/material.dart';
import 'package:when2meet/buttons/authButton.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:when2meet/screens/account/loginFormScreen.dart';

class SignUpIntroScreen extends StatefulWidget {
  const SignUpIntroScreen({super.key});

  @override
  State<SignUpIntroScreen> createState() => _SignUpIntroScreenState();
}

class _SignUpIntroScreenState extends State<SignUpIntroScreen> {
  ScreenConfig sc = ScreenConfig.instance;

  //초기화
  @override
  void initState() {
    super.initState();
  }

  //새로고침
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //변화하는 스크린 사이즈에 맞춰서 변하는 변수
    final size = MediaQuery.of(context).size;
    sc.updateScreenVariables(size);
  }

  void onLogInTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LoginFormScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        /* if (orientation == Orientation.landscape) {
          return const Scaffold(
            body: Center(
              child: Text('Plz rotate ur phone.'),
            ),
          );
        } */
        return Scaffold(
          //입력 키보드가 렌더링에 영향을 주지 않도록 설정
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorConfig.primaryColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sc.screenWidth / 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sc.screenHeight / 6.5),
                  Text(
                    "Sign up for Sync_callendar",
                    style: TextStyle(
                      fontSize: SizeConfig.size32,
                      fontWeight: FontWeight.bold,
                      color: ColorConfig.iconColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: sc.screenHeight / 20),
                  Text(
                    "Make your own schedule,",
                    style: TextStyle(
                      fontSize: SizeConfig.size16,
                      fontWeight: FontWeight.bold, // 기본 텍스트 두께
                      color: const Color.fromARGB(
                        255,
                        223,
                        209,
                        223,
                      ), // 기본 텍스트 색상
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "and share with others!",
                    style: TextStyle(
                      fontSize: SizeConfig.size16,
                      fontWeight: FontWeight.bold, // 기본 텍스트 두께
                      color: const Color.fromARGB(
                        255,
                        223,
                        209,
                        223,
                      ), // 기본 텍스트 색상
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: sc.screenHeight / 5),
                  const AuthButton(
                    auth: "Sign up",
                    icon: FaIcon(
                      FontAwesomeIcons.user,
                      color: ColorConfig.iconColor,
                    ),
                    text: "Use email & password",
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: ColorConfig.primaryColor,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: SizeConfig.size8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '이미 계정이 있으신가요?',
                    style: TextStyle(
                      fontSize: SizeConfig.size16,
                      fontWeight: FontWeight.bold, // 기본 텍스트 두께
                      color: ColorConfig.iconColor, // 기본 텍스트 색상
                    ),
                  ),
                  GapConfig.h5,
                  GestureDetector(
                    onTap: () => onLogInTap(),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: SizeConfig.size16,
                        fontWeight: FontWeight.bold, // 기본 텍스트 두께
                        color: ColorConfig.secondaryColor, // 기본 텍스트 색상
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
