import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomAsyncLoader extends StatelessWidget {
  const CustomAsyncLoader({
    super.key,
    required this.loadingText,
  });
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(loadingText),
        const SizedBox(width: 10),
        SpinKitFadingCircle(
          size: 25,
          color: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}
