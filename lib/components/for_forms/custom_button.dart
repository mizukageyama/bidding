import 'package:flutter/material.dart';

class CustomButton extends Container {
  CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.buttonPadding =
        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.splashColor = Colors.transparent,
    this.buttonColor,
    this.fontSize,
  }) : super(key: key);

  final Function? onTap;
  final String? text;
  final Color? buttonColor;
  final Color splashColor;
  final double? fontSize;
  final EdgeInsetsGeometry? buttonPadding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      splashColor: splashColor,
      onPressed: () => onTap!(),
      color: buttonColor,
      padding: buttonPadding,
      child: Text(
        text!,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
