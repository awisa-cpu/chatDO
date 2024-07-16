import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomRoundedContainer extends StatelessWidget {
  const CustomRoundedContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.color,
      required this.radius,
      required this.imageUrl,
      this.showBorder = false,
      this.padding,
      this.isImage = true,
      this.child,
      this.fit,
      this.shape});

  final double height;
  final double width;
  final Color color;
  final double radius;
  final String imageUrl;
  final bool showBorder;
  final bool isImage;
  final Widget? child;
  final BoxFit? fit;
  final BoxShape? shape;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: shape ?? BoxShape.rectangle,
        color: color,
        borderRadius: shape == null ? BorderRadius.circular(radius) : null,
        border: showBorder ? Border.all() : null,
      ),
      child: isImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Center(
                child: CachedNetworkImage(
                    fit: fit,
                    imageUrl: imageUrl,
                    placeholder: (_, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error)),
              ),
            )
          : child,
    );
  }
}
