import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String hintText;

  const InputField({
    Key? key,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
