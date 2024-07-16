import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.showPassword = false,
  });
  final String hintText;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final bool showPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(width: 0.1, color: Colors.green),
        ),
        hintText: widget.hintText,
        suffixIcon: widget.showPassword
            ? IconButton(
                onPressed: () {
                  setState(
                    () {
                      obscureText = !obscureText;
                    },
                  );
                },
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
      onSaved: widget.onSaved,
    );
  }
}
