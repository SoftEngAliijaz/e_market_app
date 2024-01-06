import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  ///var
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final Widget? suffixWidget;
  final bool? obscureText;
  final TextInputType? keyboardType;

  ///const
  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.textEditingController,
    this.validator,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: validator,
      controller: textEditingController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontWeight: FontWeight.bold),
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixWidget),
    );
  }
}
