import 'package:flutter/material.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/mainScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log in")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConfig.size36),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GapConfig.v28,
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (value) {
                  final regExp = RegExp(
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$",
                  );
                  if (value == null) {
                    "Email is required";
                  } else if (!regExp.hasMatch(value)) {
                    return "Email not valid";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) formData['email'] = newValue;
                },
              ),
              GapConfig.v16,
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                validator: (value) {
                  final regExp = RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).+$',
                  );
                  if (value == null) {
                    "Password is required";
                  } else if (!regExp.hasMatch(value) || value.length < 8) {
                    return "Password not valid";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) formData['password'] = newValue;
                },
              ),
              GapConfig.v28,
              GestureDetector(
                onTap: () => _onSubmitTap(),
                child: const FormButton(disabled: false, text: "Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
