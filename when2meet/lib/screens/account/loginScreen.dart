import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:when2meet/buttons/authButton.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  void onSignUpTap(BuildContext context) {
    Navigator.of(
      context,
    ).pop(); //top-most route page를 remove하고 그 전에 만들어졌던 page로 돌아감
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*SafeArea: Flutter에서 SafeArea는 콘텐츠가 기기의 노치, 
        상태바, 하단 네비게이션 바 등과 겹치지 않도록 안전한 영역 
        안에 배치되도록 도와주는 위젯입니다. 특히 엣지-투-엣지 
        화면을 사용하는 기기에서 유용합니다.*/
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.size40),
          child: Column(
            children: [
              GapConfig.v80,
              Text(
                "Log in to TikTok",
                style: TextStyle(
                  fontSize: SizeConfig.size28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GapConfig.v20,
              Text(
                "Manage your account, check notifications, comment on videos, and more.",
                style: TextStyle(
                  fontSize: SizeConfig.size16,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
              GapConfig.v40,
              AuthButton(
                icon: FaIcon(FontAwesomeIcons.user),
                text: "Use phone or email",
                auth: "Log in",
              ),
              GapConfig.v16,
              AuthButton(
                icon: FaIcon(FontAwesomeIcons.apple),
                text: "Continue with Facebook",
                auth: "Log in",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80, //안드로이드에서는 default = 80
        color: Colors.grey.shade50,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SizeConfig.size2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(fontSize: SizeConfig.size16),
              ),
              GapConfig.h5,
              GestureDetector(
                onTap: () => onSignUpTap(context),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
