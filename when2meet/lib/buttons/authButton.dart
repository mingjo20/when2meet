import 'package:flutter/material.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:when2meet/screens/account/loginFormScreen.dart';
import 'package:when2meet/screens/account/nameScreen.dart';

class AuthButton extends StatelessWidget {
  final FaIcon icon;
  final String text, auth;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.auth,
  });

  void _authTap(BuildContext context) {
    if (text.contains('email')) {
      if (auth == "Sign up") {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => NameScreen()));
      } else if (auth == "Log in") {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LoginFormScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //부모의 위젯 크기에 비례한 SizedBox를 만들 수 있게 해주는 widget.
    return GestureDetector(
      onTap: () => _authTap(context),
      child: FractionallySizedBox(
        widthFactor: 1, //1: 100% of parent's size
        child: Container(
          color: ColorConfig.secondaryColor,
          padding: EdgeInsets.all(SizeConfig.size14),
          child: Stack(
            //ALLOWS ONE ITEM TO BE PUT ON TOP OF ANOTHER!!
            //Row를 사용하면 아이콘을 먼저 그리고 남은 공간 중간에 text를 렌더링하여서
            //text가 정확한 중간에 위치하지 못했다. 하지만 Stack을 사용하여 서로 위치가 곂칠 수 있도록,
            //즉 위치 값이 개별적으로 설정되게 하여 text와 icon을 중간에 위치를 설정하고
            //이후 icon만 왼쪽 끝으로 위치를 재설정해 text는 가운데 icon은 왼쪽 끝으로 하도록 한다.
            alignment: Alignment.center,
            children: [
              Align(
                //위 alignment설정과는 무관하게 따로 alignment를 설정해줄 수 있음음
                alignment: Alignment.centerLeft,
                child: icon,
              ),
              /*해당 오류는 Expanded 위젯이 Stack 위젯 안에서 사용되고 있어 발생한 
                문제입니다. Expanded 위젯은 Flex 위젯(Row나 Column과 같은) 내부에서만 
                동작하도록 설계되었습니다.
                
                위 오류로 인해서 Expanded를 SizedBox로 교체. 결과값이 달라지지는 않음
                왜냐하면 Stack을 사용했기에 Stack안의 공간은 서로 나누어서 할당되는게 아니라
                widget별로 할당되기 때문이다.*/
              //Expanded(
              SizedBox(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.size14, // 기본 텍스트 크기 (bodyMedium에 한함)
                    fontWeight: FontWeight.w500, // 기본 텍스트 두께
                    color: ColorConfig.iconColor, // 기본 텍스트 색상
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
