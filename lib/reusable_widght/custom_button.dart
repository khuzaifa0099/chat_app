import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function()? buttonFunction;
  String textString;
  double textSize, buttonWidth, buttonHeight;
  Color buttonColor, textColor;
  FontWeight textWeight;
  // bool isLoading;

  CustomButton({
    Key? key,
    required this.buttonFunction,
    required this.textString,
    required this.buttonColor,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.textColor,
    required this.textSize,
    required this.textWeight,
    // required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonFunction,
      child:
      Text(
        textString,
        style: TextStyle(
            fontSize: textSize, color: textColor, fontWeight: textWeight),
      ),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(buttonWidth, buttonHeight),
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}