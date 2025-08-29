import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';

/// 3-4-4 패턴(XXX-XXXX-XXXX) 자동 하이픈 포매터
class KoreanPhoneNumberFormatter extends TextInputFormatter {
  static final _digitsOnly = RegExp(r'\d');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1) 숫자만 추출하고 11자리로 제한
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final truncated = digits.length > 11 ? digits.substring(0, 11) : digits;

    // 2) 3-4-4로 하이픈 삽입
    final buf = StringBuffer();
    for (int i = 0; i < truncated.length; i++) {
      buf.write(truncated[i]);
      if (i == 2 || i == 6) {
        if (i != truncated.length - 1) buf.write('-');
      }
    }
    final formatted = buf.toString();

    // 3) 커서 위치 보정: 입력한 숫자 개수를 기준으로 하이픈 만큼 가산
    final rawCursor = newValue.selection.baseOffset.clamp(
      0,
      newValue.text.length,
    );
    final typedDigitsBeforeCursor = RegExp(
      r'\d',
    ).allMatches(newValue.text.substring(0, rawCursor)).length;

    int targetOffset;
    if (typedDigitsBeforeCursor <= 3) {
      targetOffset = typedDigitsBeforeCursor; // 0..3
    } else if (typedDigitsBeforeCursor <= 7) {
      targetOffset = typedDigitsBeforeCursor + 1; // 하이픈 1개 포함
    } else {
      targetOffset = typedDigitsBeforeCursor + 2; // 하이픈 2개 포함
    }
    targetOffset = targetOffset.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: targetOffset),
      composing: TextRange.empty,
    );
  }
}

class PhoneNumberTextField extends StatelessWidget {
  const PhoneNumberTextField({
    super.key,
    required TextEditingController textController,
    String? hintTextValue,
  }) : _textController = textController,
       _hintTextValue = hintTextValue ?? '010-1234-5678';

  final TextEditingController _textController;
  final String _hintTextValue;

  static final RegExp _phonePattern = RegExp(r'^\d{3}-\d{4}-\d{4}$');

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

      // 휴대폰 번호 입력 전용 UX
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      textCapitalization: TextCapitalization.none,

      // 입력 단계에서 숫자만 허용 → 11자리 제한 → 자동 하이픈
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11), // 숫자 11자리(3+4+4)
        KoreanPhoneNumberFormatter(),
      ],

      // 제출 시 최종 검증
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return 'value required';
        if (!_phonePattern.hasMatch(v)) {
          return '형식은 XXX-XXXX-XXXX 이어야 합니다.';
        }
        return null;
      },
    );
  }
}
