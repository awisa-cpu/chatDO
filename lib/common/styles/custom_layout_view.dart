import 'package:flutter/material.dart';

class CustomLayoutView extends StatelessWidget {
  const CustomLayoutView({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8.5),
          child: child,
        ),
      ),
    );
  }
}
