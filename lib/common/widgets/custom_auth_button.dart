import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({super.key, required this.onnTap, required this.authText});
  final VoidCallback onnTap;
  final String authText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onnTap,
        child:  Text(authText),
      ),
    );
  }
}
