import 'package:flutter/material.dart';
import 'package:when2meet/screens/account/passwordScreen.dart';
import 'package:when2meet/textFields/englishTextField.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/account/emailScreen.dart';
import 'package:when2meet/textFields/phonenumTextField.dart';

class PhonenumScreen extends StatefulWidget {
  const PhonenumScreen({super.key});

  @override
  State<PhonenumScreen> createState() => _PhonenumScreenState();
}

class _PhonenumScreenState extends State<PhonenumScreen> {
  ScreenConfig sc = ScreenConfig.instance;
  final TextEditingController _phonenumController = TextEditingController();
  String _phonenum = '';

  //초기화
  @override
  void initState() {
    super.initState();

    _phonenumController.addListener(() {
      setState(() {
        _phonenum = _phonenumController.text;
      });
    });
  }

  //새로고침
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //변화하는 스크린 사이즈에 맞춰서 변하는 변수
    final size = MediaQuery.of(context).size;
    sc.updateScreenVariables(size);
  }

  @override
  void dispose() {
    //위에 _usernameController.text의 입력 텍스트 값을 _username에 저장하면
    //_usernameController.text는 더 이상 필요가 없어진다. 따라서 메모리에서
    //삭제해주는 작업이 필요하다. 앱을 사용하다보면 메모리가 부족할 때가 생기기
    //때문이다.
    _phonenumController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  //여기서 context를 받지 않는 이유는 stateful위젯에서는 context가 state안에서는는
  //어디에서든 접근이 가능하기 때문이다.
  void _onNextTap() {
    if (_phonenum.isNotEmpty) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const PasswordScreen()));
    }
  }

  //입력한 휴대폰 번호가 valid한지 확인
  bool _isPhoneValid(String phone) {
    final regExp = RegExp(r'^\d{3}-\d{4}-\d{4}$');
    return regExp.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //입력 키보드가 렌더링에 영향을 주지 않도록 설정
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorConfig.primaryColor,
        foregroundColor: ColorConfig.iconColor,
        title: Text(
          "Phone Number",
          style: TextStyle(color: ColorConfig.iconColor),
        ),
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
              'Can I Have Your Number?',
              style: TextStyle(
                fontSize: SizeConfig.size24,
                fontWeight: FontWeight.w700,
                color: ColorConfig.iconColor,
              ),
            ),
            GapConfig.v16,
            Text(
              'Don\'t worry, I won\'t call you.',
              style: TextStyle(
                fontSize: SizeConfig.size16,
                fontWeight: FontWeight.w600,
                color: ColorConfig.iconColor,
              ),
            ),
            PhoneNumberTextField(
              textController: _phonenumController,
              hintTextValue: "010-1234-5678",
            ),
            GapConfig.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(disabled: !_isPhoneValid(_phonenum)),
            ),
          ],
        ),
      ),
    );
  }
}
