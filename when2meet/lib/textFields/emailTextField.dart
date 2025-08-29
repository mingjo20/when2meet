import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';

typedef EmailValidateCallback =
    void Function(bool isValid, String? error, String value);

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required TextEditingController emailController,
    required this.formData,
    this.onValidation, // ← 상위로 알릴 콜백 (선택)
  }) : _emailController = emailController;

  final TextEditingController _emailController;
  final Map<String, String> formData;
  final EmailValidateCallback? onValidation;

  // 허용 문자: 영문/숫자 + 이메일에서 흔히 쓰는 특수문자
  static final RegExp _allowedChars = RegExp(
    r"^[a-zA-Z0-9@._\-+!#$%&'*+/=?^_`{|}~]+$",
  );

  static final RegExp _emailFormat = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$",
  );

  static String? _validate(String value) {
    final v = value.trim();
    if (v.isEmpty) {
      return "Email is required";
    }
    if (!_allowedChars.hasMatch(v)) {
      return "Only English letters, numbers and allowed special characters are permitted";
    }
    if (!_emailFormat.hasMatch(v)) {
      return "Email not valid";
    }
    return null; // valid
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
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

      // 입력 자체 차단(비허용 문자 입력 방지)
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r"[a-zA-Z0-9@._\-+!#$%&'*+/=?^_`{|}~]"),
        ),
      ],

      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],

      // 폼 UI용 에러 메시지 반환
      validator: (value) => _validate(value ?? ''),

      // 실시간으로 상위에 유효/무효 알림
      onChanged: (value) {
        final err = _validate(value);
        onValidation?.call(err == null, err, value.trim());
      },

      onSaved: (newValue) {
        final v = (newValue ?? '').trim();
        if (v.isNotEmpty) formData['email'] = v;
      },
    );
  }
}
