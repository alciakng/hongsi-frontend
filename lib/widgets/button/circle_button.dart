import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';

class CircleButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final double circleHeight;
  final double iconSize;
  final Function? onPressed;
  final IconData iconData;
  final Color? splashColor;
  const CircleButton(
      {Key? key,
      this.backgroundColor = AppColor.persimmon,
      this.iconColor = AppColor.white,
      this.borderColor = AppColor.white,
      this.circleHeight = 40,
      this.iconSize = 20,
      this.onPressed,
      required this.iconData,
      this.splashColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: backgroundColor,
      elevation: 0.0,
      padding: EdgeInsets.zero,
      height: circleHeight,
      minWidth: circleHeight,
      shape: CircleBorder(side: BorderSide(color: borderColor, width: 0.5)),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Icon(
        iconData,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
