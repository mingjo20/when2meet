import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/account/passwordScreen.dart';
import 'package:when2meet/screens/account/phonenumScreen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _email = '';

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    //위에 _usernameController.text의 입력 텍스트 값을 _username에 저장하면
    //_usernameController.text는 더 이상 필요가 없어진다. 따라서 메모리에서
    //삭제해주는 작업이 필요하다. 앱을 사용하다보면 메모리가 부족할 때가 생기기
    //때문이다.
    _emailController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    final regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$",
    );
    if (!regExp.hasMatch(_email)) {
      return "Email not valid";
    }
    return null;
  }

  void _onScaffoldTap() {
    //입력 창이 아니라 scaffold의 아무 부분이나 눌렀을 경우 unfocus, 즉 입력창에
    //커서가 더 이상 뜨지 않는 상태가 된다. 이 말은 입력창을 사용하지 않는 상태이며
    //키보드를 사용하지 않는다는 뜻. 따라서 키보드를 다시 집어넣는 기능을 추가해야한다.
    //이는 .unfocus()를 하면 됨.
    FocusScope.of(context).unfocus();
  }

  void _onNextTap() {
    if (_email.isNotEmpty && _isEmailValid() == null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const PhonenumScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        //입력 키보드가 렌더링에 영향을 주지 않도록 설정
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConfig.primaryColor,
        appBar: AppBar(
          backgroundColor: ColorConfig.primaryColor,
          foregroundColor: ColorConfig.iconColor,
          title: Text("Email", style: TextStyle(color: ColorConfig.iconColor)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConfig.size28,
            vertical: SizeConfig.size52,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What is your email?',
                style: TextStyle(
                  fontSize: SizeConfig.size24,
                  fontWeight: FontWeight.w700,
                  color: ColorConfig.iconColor,
                ),
              ),
              GapConfig.v16,
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                //키보드에서 'done' 혹은 '완료'버튼을 눌렀을 때도 next버튼을
                //눌렀을 때와 동일하게 작동하게 만드는 것
                onEditingComplete: _onNextTap,
                style: TextStyle(color: ColorConfig.iconColor),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: ColorConfig.iconColor.withValues(alpha: 0.5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusColor: ColorConfig.iconColor,
                  hoverColor: ColorConfig.iconColor,
                  // filled: true,
                  // fillColor: ColorConfig.secondaryColor, // 배경색 쓰실 거면 filled도 함께
                ),
                cursorColor: ColorConfig.iconColor,
                // 입력 단계에서 한글/이모지/허용 외 문자 차단
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z0-9@._\-+!#$%&'*+/=?^_`{|}~]"),
                  ),
                ],
              ),
              GapConfig.v16,
              //'_email.isEmpty || _isEmailValid() != null'의 논리연산 값이 전달됨
              GestureDetector(
                onTap: _onNextTap,
                child: FormButton(
                  disabled: _email.isEmpty || _isEmailValid() != null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
