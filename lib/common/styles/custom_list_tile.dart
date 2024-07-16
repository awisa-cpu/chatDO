import 'package:chatdo/common/widgets/custom_rounded_container.dart';
import 'package:chatdo/setup.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.icon,
      required this.mainText,
      this.subText,
      this.iconBgColor = Colors.white,
      this.showTrailing = true,
      this.child,
      required this.onTap});

  final Icon icon;
  final String mainText;
  final String? subText;
  final Color iconBgColor;
  final bool showTrailing;
  final Widget? child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: osWidth(context) * 0.90,
      height: osHeight(context) * 0.08,
      child: Row(
        children: [
          CustomRoundedContainer(
            height: 50,
            width: 50,
            color: iconBgColor,
            radius: 100,
            imageUrl: '',
            isImage: false,
            child: icon,
          ),
          const SizedBox(width: 23),
          subText != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(mainText), Text(subText!)],
                )
              : Text(mainText),
          const Spacer(),
          showTrailing == true && child == null
              ? GestureDetector(
                  onTap: onTap,
                  child: CustomRoundedContainer(
                    height: 50,
                    width: 50,
                    color: Colors.grey.withOpacity(0.2),
                    radius: 10,
                    imageUrl: '',
                    isImage: false,
                    child: const Icon(Icons.chevron_right),
                  ),
                )
              : child!,
        ],
      ),
    );
  }
}
