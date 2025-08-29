import 'package:flutter/material.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/account/signupIntroScreen.dart';
import 'package:when2meet/screens/mainScreen.dart';
import 'package:when2meet/textFields/emailTextField.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  /*폼(Form) 위젯을 관리하기 위한 고유 키를 생성하는 코드입니다. 
  이를 통해 Flutter 애플리케이션에서 폼 상태를 추적하거나 유효성 
  검사를 수행할 수 있습니다. 
  
  주요 메서드
    validate(): 폼에 연결된 모든 필드의 유효성 검사를 실행합니다. 모든 
                필드가 유효하면 true, 그렇지 않으면 false를 반환합니다.
    save(): 폼의 현재 상태를 저장합니다.
    reset(): 폼 필드의 상태를 초기화합니다.
  */
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  final TextEditingController _emailController = TextEditingController();
  String _email = '';
  final TextEditingController _passwordController = TextEditingController();
  String _password = '';

  //초기화
  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });

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
    _emailController.dispose();
    _passwordController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        //로그인하고 나서는 다시 돌아갈 수 없게 그 전 페이지, 즉 로그인할 때 썻던 페이지는 삭제한다.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          //remove할 과거 페이지의 수를 정할 수 있음
          //Function(Route<dynamic>)의 값이 true인 경우 전 페이지들을 남겨놓고
          //false인 경우 전 페이지들을 모두 지운다.
          (route) => false,
        );
        /*
          print(route)의 값:

          MaterialPageRoute<dynamic>(RouteSettings(none, null), animation: AnimationController#7204b(⏭ 1.000; paused; for MaterialPageRoute<dynamic>(null)))
          MaterialPageRoute<dynamic>(RouteSettings(none, null), animation: AnimationController#d6b6f(⏭ 1.000; paused; for MaterialPageRoute<dynamic>(null)))
          MaterialPageRoute<dynamic>(RouteSettings("/", null), animation: AnimationController#1f152(⏭ 1.000; paused; for MaterialPageRoute<dynamic>(/))) 
        */
      }
    }
  }

  void _onSignUpTap() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignUpIntroScreen()),
      //remove할 과거 페이지의 수를 정할 수 있음
      //Function(Route<dynamic>)의 값이 true인 경우 전 페이지들을 남겨놓고
      //false인 경우 전 페이지들을 모두 지운다.
      (route) => false,
    );
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
        title: Text("Log in", style: TextStyle(color: ColorConfig.iconColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConfig.size36),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GapConfig.v28,
              EmailTextField(
                emailController: _emailController,
                formData: formData,
              ),
              GapConfig.v16,
              TextFormField(
                controller: _passwordController,
                style: TextStyle(
                  // 입력된 텍스트 색상
                  color: ColorConfig.iconColor,
                ),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    // hint 텍스트 색상
                    color: ColorConfig.iconColor.withValues(
                      alpha: 0.5,
                    ), // 약간 흐리게 보이게
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
              GapConfig.v28,
              GestureDetector(
                onTap: () => _onSubmitTap(),
                child: FormButton(
                  disabled: (_email.isEmpty || _password.isEmpty),
                  text: "Log in",
                ),
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
                '계정이 없으신가요?',
                style: TextStyle(
                  fontSize: SizeConfig.size16,
                  fontWeight: FontWeight.bold, // 기본 텍스트 두께
                  color: ColorConfig.iconColor, // 기본 텍스트 색상
                ),
              ),
              GapConfig.h5,
              GestureDetector(
                onTap: () => _onSignUpTap(),
                child: Text(
                  'Sign Up',
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
  }
}
