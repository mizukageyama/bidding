import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.validator,
      this.textInputAction = TextInputAction.next,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.hideLabelTyping = false,
      required this.onChanged,
      required this.onSaved})
      : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final int minLines;
  final int? maxLines;
  final void Function(String) onChanged;
  final void Function(String?)? onSaved;
  final bool hideLabelTyping;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: maroonColor,
            ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: whiteColor,
          labelText: labelText,
          floatingLabelBehavior: hideLabelTyping
              ? FloatingLabelBehavior.never
              : FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: maroonColor),
              borderRadius: BorderRadius.circular(10)),
        ),
        textInputAction: textInputAction,
        controller: controller,
        onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: minLines,
        validator: validator,
      ),
    );
  }
}
