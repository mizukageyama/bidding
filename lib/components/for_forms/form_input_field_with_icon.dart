import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class FormInputFieldWithIcon extends StatelessWidget {
  const FormInputFieldWithIcon(
      {Key? key,
      this.controller,
      required this.iconPrefix,
      required this.labelText,
      required this.validator,
      this.textInputAction = TextInputAction.next,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.suffixIcon,
      this.hideLabelTyping = true,
      this.capitalizedFirst = false,
      required this.onChanged,
      this.onSaved})
      : super(key: key);

  final TextEditingController? controller;
  final IconData iconPrefix;
  final Widget? suffixIcon;
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
  final bool capitalizedFirst;

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
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: whiteColor,
          prefixIcon: Icon(iconPrefix),
          suffixIcon: suffixIcon,
          labelText: labelText,
          floatingLabelBehavior: hideLabelTyping
              ? FloatingLabelBehavior.never
              : FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
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
        maxLines: 1,
        minLines: minLines,
        textCapitalization: capitalizedFirst
            ? TextCapitalization.words
            : TextCapitalization.none,
        validator: validator,
      ),
    );
  }
}
