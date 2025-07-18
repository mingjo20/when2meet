import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/gapConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/mainScreen.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  DateTime initialDate = DateTime.now();
  bool _2young = true;

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initialDate);
    _tooYoung();
  }

  @override
  void dispose() {
    //위에 _usernameController.text의 입력 텍스트 값을 _username에 저장하면
    //_usernameController.text는 더 이상 필요가 없어진다. 따라서 메모리에서
    //삭제해주는 작업이 필요하다. 앱을 사용하다보면 메모리가 부족할 때가 생기기
    //때문이다.
    _birthdayController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  //여기서 context를 받지 않는 이유는 stateful위젯에서는 context가 state안에서는는
  //어디에서든 접근이 가능하기 때문이다.
  void _onNextTap() {
    if (!_2young) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        //remove할 과거 페이지의 수를 정할 수 있음
        //Function(Route<dynamic>)의 값이 true인 경우 전 페이지들을 남겨놓고
        //false인 경우 전 페이지들을 모두 지운다.
        (route) => false,
      );
    }
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
    _tooYoung();
    setState(() {});
  }

  void _tooYoung() {
    final year = int.parse(
      (_birthdayController.value.text.split("-").elementAt(0)),
    );
    final month = int.parse(
      (_birthdayController.value.text.split("-").elementAt(1)),
    );
    final day = int.parse(
      (_birthdayController.value.text.split("-").elementAt(2)),
    );
    DateTime currentDate = DateTime(year, month, day);
    if (DateTime.now().difference(currentDate).inDays > 2556) {
      _2young = false;
    } else {
      _2young = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConfig.size28,
          vertical: SizeConfig.size56,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'When\'s your birthday?',
              style: TextStyle(
                fontSize: SizeConfig.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            GapConfig.v16,
            Text(
              'Your birthday won\'t be shown publicly.',
              style: TextStyle(
                fontSize: SizeConfig.size16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            TextField(
              enabled: false,
              controller: _birthdayController,
              decoration: InputDecoration(
                errorText: _2young ? "Too young" : null,
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
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(disabled: false),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 200,
        child: CupertinoDatePicker(
          onDateTimeChanged: _setTextFieldDate,
          mode: CupertinoDatePickerMode.date,
          maximumDate: initialDate,
          initialDateTime: initialDate,
        ),
      ),
    );
  }
}
