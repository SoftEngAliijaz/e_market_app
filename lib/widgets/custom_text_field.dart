import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final Widget? suffixWidget;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    this.hintText,
    this.prefixIcon,
    required this.textEditingController,
    this.validator,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text, // Default to TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
          obscureText: obscureText,
          validator: validator,
          controller: textEditingController,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(fontWeight: FontWeight.bold),
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixWidget,
          ),
        ),
      ),
    );
  }
}
