import 'package:flutter/material.dart';

class CustomHeaderTexts extends StatelessWidget {
  const CustomHeaderTexts({
    super.key,
    required this.mainText,
    required this.subText,
  });
  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(mainText, style: Theme.of(context).textTheme.titleLarge),
        Text(
          subText,
          style:
              Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.grey),
        ),
      ],
    );
  }
}
