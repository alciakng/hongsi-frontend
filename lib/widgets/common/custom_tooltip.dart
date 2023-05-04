import 'package:flutter/material.dart';
import 'package:hongsi_project/helper/utility.dart';

class CustomTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  CustomTooltip({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();

    return Tooltip(
      key: key,
      showDuration: const Duration(seconds: 1),
      message: message,
      child: InkWell(
        onTap: () {
          Utility.logEvent('tooltip');
          key.currentState!.ensureTooltipVisible();
        },
        onDoubleTap: () {
          Utility.logEvent('tooltip');
          key.currentState!.ensureTooltipVisible();
        },
        onLongPress: () {
          Utility.logEvent('tooltip');
          key.currentState!.ensureTooltipVisible();
        },
        child: child,
      ),
    );
  }

  static void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
