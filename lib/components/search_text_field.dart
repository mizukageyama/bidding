import 'package:bidding/components/for_forms/input_field.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField(
      {Key? key,
      required this.topLabel,
      required this.controller,
      required this.onSaved})
      : super(key: key);
  final String topLabel;
  final TextEditingController controller;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          topLabel,
          style: robotoMedium.copyWith(
            color: greyColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InputField(
          hideLabelTyping: true,
          labelText: 'Search here...',
          onChanged: (value) {
            return;
          },
          onSaved: onSaved,
          controller: controller,
        ),
      ],
    );
  }
}
