import 'package:flutter/material.dart';

class FormInputFieldWithIcon extends StatelessWidget {
   const FormInputFieldWithIcon(
      {
      required this.iconPrefix,
      required this.labelText,
      this.textInputAction = TextInputAction.next,
      this.keyboardType = TextInputType.text,
     //this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.suffixIcon,});

  final IconData iconPrefix;
  final Widget? suffixIcon;
  final String labelText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(iconPrefix),
          suffixIcon: suffixIcon,
          labelText: labelText,
          border: InputBorder.none),
      textInputAction: textInputAction,
      
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      
    );
  }
}
