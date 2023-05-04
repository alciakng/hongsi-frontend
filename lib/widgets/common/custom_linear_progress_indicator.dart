import 'package:flutter/material.dart';

const double _linearProgressIndicatorHeight = 0.0;

class CustomLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  CustomLinearProgressIndicator({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, _linearProgressIndicatorHeight);
  }

  @override
  late Size preferredSize;
}
