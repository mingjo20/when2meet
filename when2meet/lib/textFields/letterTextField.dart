import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';

class LetterTextField extends StatelessWidget {
  const LetterTextField({
    super.key,
    required TextEditingController textController,
    required String hintTextValue,
  }) : _textController = textController,
       _hintTextValue = hintTextValue;

  final TextEditingController _textController;
  final String _hintTextValue;

  // 허용 문자: 영어 + 한글(음절/자모) + 공백
  static final RegExp _allowedChars = RegExp(r"^[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ\s]+$");

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
      ),
      cursorColor: ColorConfig.iconColor,

      // 입력 단계에서 영어/한글(자모 포함)/공백 외 문자 차단
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ\s]")),
      ],

      // 제출 시 최종 검증
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) {
          return "value required";
        }
        if (!_allowedChars.hasMatch(v)) {
          return "Only Korean (including Jamo), English letters, and spaces are permitted";
        }
        return null;
      },

      textCapitalization: TextCapitalization.none,
    );
  }
}
