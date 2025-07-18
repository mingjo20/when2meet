import 'package:flutter/material.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';

class FormButton extends StatelessWidget {
  const FormButton({super.key, required this.disabled, this.text = "Next"});

  final String text;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.size5),
          color: disabled ? Colors.grey.shade300 : ColorConfig.secondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SizeConfig.size16),
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              color: disabled ? Colors.grey.shade500 : Colors.white,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
