import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({Key? key, required this.onChanged})
      : super(key: key);
  final void Function(String?) onChanged;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  String? userType = 'Seller';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Radio(
            value: 'Seller',
            groupValue: userType,
            activeColor: maroonColor,
            onChanged: (value) {
              setState(() {
                userType = value.toString();
              });
              widget.onChanged(value.toString());
            }),
        const Text(
          'Seller',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              fontSize: 13),
        ),
        const SizedBox(
          width: 45,
        ),
        Radio(
            value: 'Bidder',
            activeColor: maroonColor,
            groupValue: userType,
            onChanged: (value) {
              setState(() {
                userType = value.toString();
              });
              widget.onChanged(value.toString());
            }),
        const Text(
          'Bidder',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              fontSize: 13),
        )
      ])
    ]);
  }
}
