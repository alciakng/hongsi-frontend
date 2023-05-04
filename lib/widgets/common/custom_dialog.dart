import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';

import 'custom_flat_button.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final VoidCallback callback;
  final Color? closeColor;
  final Color? confirmColor;

  CustomDialog(
      {this.title,
      required this.child,
      required this.callback,
      this.closeColor = AppColor.lightGrey,
      this.confirmColor = AppColor.persimmon});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();

    return AlertDialog(
        title: title ?? null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              child: child,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomFlatButton(
                      label: '닫기',
                      color: closeColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      borderRadius: 4.0,
                      whichBorder: "bottomLeft",
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomFlatButton(
                        label: '확인',
                        color: confirmColor,
                        onPressed: callback,
                        borderRadius: 4.0,
                        whichBorder: "bottomRight"),
                  ),
                ),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0))));
  }
}
