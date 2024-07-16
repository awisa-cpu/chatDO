import 'package:flutter/material.dart';

class CustomNavButtons extends StatelessWidget {
  const CustomNavButtons({
    super.key,
    required this.onTap,
    required this.mainText,
    required this.hintText,
  });
  final VoidCallback onTap;
  final String mainText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$mainText ', style: Theme.of(context).textTheme.bodyLarge),
        GestureDetector(
          onTap: onTap,
          child: Text(
            '$hintText!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
