import 'package:flutter/material.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/account/emailScreen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _username = '';

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    //위에 _usernameController.text의 입력 텍스트 값을 _username에 저장하면
    //_usernameController.text는 더 이상 필요가 없어진다. 따라서 메모리에서
    //삭제해주는 작업이 필요하다. 앱을 사용하다보면 메모리가 부족할 때가 생기기
    //때문이다.
    _usernameController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  //여기서 context를 받지 않는 이유는 stateful위젯에서는 context가 state안에서는는
  //어디에서든 접근이 가능하기 때문이다.
  void _onNextTap() {
    if (_username.isNotEmpty) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const EmailScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorConfig.primaryColor,
        foregroundColor: ColorConfig.iconColor,
        title: Text("Sign up", style: TextStyle(color: ColorConfig.iconColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConfig.size28,
          vertical: SizeConfig.size56,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create username',
              style: TextStyle(
                fontSize: SizeConfig.size24,
                fontWeight: FontWeight.w700,
                color: ColorConfig.iconColor,
              ),
            ),
            GapConfig.v16,
            Text(
              'You can always change this later.',
              style: TextStyle(
                fontSize: SizeConfig.size16,
                fontWeight: FontWeight.w600,
                color: ColorConfig.iconColor,
              ),
            ),
            TextField(
              controller: _usernameController,
              style: TextStyle(
                // 입력된 텍스트 색상
                color: ColorConfig.iconColor,
              ),
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(
                  // hint 텍스트 색상
                  color: ColorConfig.iconColor.withOpacity(0.5), // 약간 흐리게 보이게
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusColor: ColorConfig.iconColor,
                hoverColor: ColorConfig.iconColor,
                fillColor: ColorConfig.secondaryColor,
              ),
              cursorColor: ColorConfig.iconColor,
            ),

            GapConfig.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(disabled: _username.isEmpty),
            ),
          ],
        ),
      ),
    );
  }
}
