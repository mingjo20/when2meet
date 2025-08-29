import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';

class EnglishTextField extends StatelessWidget {
  const EnglishTextField({
    super.key,
    required TextEditingController textController,
    required String hintTextValue,
  }) : _textController = textController,
       _hintTextValue = hintTextValue;

  final TextEditingController _textController;
  final String _hintTextValue;

  // 허용 문자: 영문/숫자 + 이메일에서 자주 쓰는 특수문자
  static final RegExp _allowedChars = RegExp(
    r"^[a-zA-Z0-9@._\-+!#$%&'*+/=?^_`{|}~]+$",
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      style: TextStyle(color: ColorConfig.iconColor),
      decoration: InputDecoration(
        hintText: _hintTextValue,
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
        //filled: true, // ← fillColor 적용하려면 필요
        //fillColor: ColorConfig.secondaryColor,
      ),
      cursorColor: ColorConfig.iconColor,

      // 입력 단계에서 한글/이모지/허용 외 문자 차단
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r"[a-zA-Z0-9@._\-+!#$%&'*+/=?^_`{|}~]"),
        ),
      ],

      // 제출 시 최종 검증
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) {
          return "value required";
        }
        if (!_allowedChars.hasMatch(v)) {
          return "Only English letters, numbers and allowed special characters are permitted";
        }
        return null;
      },

      // (선택) 영문 전용 입력 UX
      textCapitalization: TextCapitalization.none,
      // keyboardType: TextInputType.emailAddress, // 이메일 전용이라면 활성화
      // autofillHints: const [AutofillHints.email], // 이메일 전용이라면 활성화
    );
  }
}
