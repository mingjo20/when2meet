import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/account/BirthdayScreen.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _password = '';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    //위에 _usernameController.text의 입력 텍스트 값을 _username에 저장하면
    //_usernameController.text는 더 이상 필요가 없어진다. 따라서 메모리에서
    //삭제해주는 작업이 필요하다. 앱을 사용하다보면 메모리가 부족할 때가 생기기
    //때문이다.
    _passwordController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  bool _isPasswordLengthValid() {
    return _password.isNotEmpty && _password.length > 8;
  }

  bool _isPasswordContained() {
    final regExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).+$',
    );
    return regExp.hasMatch(_password);
  }

  bool _isPasswordValid() {
    setState(() {});
    return _isPasswordLengthValid() && _isPasswordContained();
  }

  void _onScaffoldTap() {
    //입력 창이 아니라 scaffold의 아무 부분이나 눌렀을 경우 unfocus, 즉 입력창에
    //커서가 더 이상 뜨지 않는 상태가 된다. 이 말은 입력창을 사용하지 않는 상태이며
    //키보드를 사용하지 않는다는 뜻. 따라서 키보드를 다시 집어넣는 기능을 추가해야한다.
    //이는 .unfocus()를 하면 됨.
    FocusScope.of(context).unfocus();
  }

  void _onNextTap() {
    if (_isPasswordValid()) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const BirthdayScreen()));
    }
  }

  void _onClearTap() {
    _passwordController.clear();
    setState(() {});
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(title: const Text("Password")),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConfig.size28,
            vertical: SizeConfig.size56,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create password',
                style: TextStyle(
                  fontSize: SizeConfig.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GapConfig.v16,
              TextField(
                obscureText: _obscureText,
                controller: _passwordController,
                autocorrect: false,
                //키보드에서 'done' 혹은 '완료'버튼을 눌렀을 때도 next버튼을
                //눌렀을 때와 동일하게 작동하게 만드는 것
                onEditingComplete: _onNextTap,
                decoration: InputDecoration(
                  //각각 앞과 뒤에 오는 아이콘으로 focus되면 색갈이 바뀐다.
                  /*prefixIcon: Icon(Icons.ac_unit),
                  suffixIcon: Icon(Icons.abc),*/
                  suffix: Row(
                    //mainAxisSize를 최소화하지 않으면 최대치로 설정이 되어서 text를 입력해야 하는 공간까지 침범한다.
                    //따라서 mainAxisSize를 최소화하여 딱 icon사이즈만큼 icon을 위한 공간이 할당되도록 한다.
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _onClearTap, //작성중인던 것 전부 삭제
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade500,
                          size: SizeConfig.size20,
                        ),
                      ),
                      GapConfig.h14,
                      GestureDetector(
                        onTap: _toggleObscureText,
                        child: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          color: Colors.grey.shade500,
                          size: SizeConfig.size20,
                        ),
                      ),
                    ],
                  ),
                  hintText: "Make it strong",
                  //enable: textField를 클릭하여 입력을 시도 혹은 하는 중일 때
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
              GapConfig.v16,
              const Text(
                'Your password must have: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GapConfig.v16,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: SizeConfig.size20,
                    color: _isPasswordLengthValid()
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  GapConfig.h5,
                  const Text('8 to 20 characters'),
                ],
              ),
              GapConfig.v16,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: SizeConfig.size20,
                    color: _isPasswordContained()
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  GapConfig.h5,
                  const Text(
                    'uppercase letters, lowercase letters, numbers, and symbols.',
                  ),
                ],
              ),
              GapConfig.v28,
              GestureDetector(
                onTap: _onNextTap,
                child: FormButton(disabled: !_isPasswordValid()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
