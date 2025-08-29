import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:when2meet/buttons/formButton.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';
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
  //bool _2young = true;

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initialDate);
    //_tooYoung();
  }

  @override
  void dispose() {
    _birthdayController.dispose();

    //super.dispose()를 가장 마지막에 두는 것이 바람직하다. 왜냐하면
    //작은 것 부터 치우고 그 다음을 처리하는 것이 안전하기 때문
    super.dispose();
  }

  //여기서 context를 받지 않는 이유는 stateful위젯에서는 context가 state안에서는는
  //어디에서든 접근이 가능하기 때문이다.
  void _onNextTap() {
    /*
    if (!_2young) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        //remove할 과거 페이지의 수를 정할 수 있음
        //Function(Route<dynamic>)의 값이 true인 경우 전 페이지들을 남겨놓고
        //false인 경우 전 페이지들을 모두 지운다.
        (route) => false,
      );
    }
    */
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      //remove할 과거 페이지의 수를 정할 수 있음
      //Function(Route<dynamic>)의 값이 true인 경우 전 페이지들을 남겨놓고
      //false인 경우 전 페이지들을 모두 지운다.
      (route) => false,
    );
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    final year = int.parse((textDate.split("-").elementAt(0)));
    final month = int.parse((textDate.split("-").elementAt(1)));
    final day = int.parse((textDate.split("-").elementAt(2)));
    final visDate = "$month-$day-$year";
    _birthdayController.value = TextEditingValue(text: visDate);
    print("$textDate $visDate\n");
    //_tooYoung();
    setState(() {});
  }

  /*
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorConfig.primaryColor,
        foregroundColor: ColorConfig.iconColor,
        title: Text(
          "Date of Birth",
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
              'When\'s your birthday?',
              style: TextStyle(
                fontSize: SizeConfig.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            GapConfig.v16,
            TextField(
              enabled: false,
              controller: _birthdayController,
              style: TextStyle(color: ColorConfig.iconColor),
              decoration: InputDecoration(
                //errorText: _2young ? "Too young" : null,
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConfig.iconColor),
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
              child: FormButton(disabled: false),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorConfig.primaryColor,
        shadowColor: Colors.white,
        height: 200,
        child: CupertinoTheme(
          data: CupertinoTheme.of(context).copyWith(
            // 선택된 행(가운데 라인)의 텍스트 스타일
            textTheme: const CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                color: ColorConfig.iconColor, // ← 바꾸고 싶은 색
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              // 만약 플러터 버전에 따라 위 속성이 적용되지 않으면 아래도 시도
              // pickerTextStyle: TextStyle(color: Colors.white),
            ),
          ),

          child: CupertinoDatePicker(
            onDateTimeChanged: _setTextFieldDate,
            mode: CupertinoDatePickerMode.date,
            maximumDate: initialDate,
            initialDateTime: initialDate,
          ),
        ),
      ),
    );
  }
}
