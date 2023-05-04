import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';

Widget customTitleText(String? title, {BuildContext? context}) {
  return Text(
    title ?? '',
    style: const TextStyle(
      color: Colors.black87,
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
  );
}

Widget customIcon({
  required IconData icon,
  bool isEnable = false,
  double size = 18,
  bool istwitterIcon = true,
  bool isFontAwesomeSolid = false,
  Color? iconColor,
  double paddingIcon = 10,
}) {
  iconColor = iconColor ?? AppColor.lightGrey;
  return Icon(
    icon,
    size: size,
    color: isEnable ? AppColor.persimmon : iconColor,
  );
}

Widget customText(
  String? msg, {
  Key? key,
  TextStyle? style,
  TextAlign textAlign = TextAlign.justify,
  TextOverflow overflow = TextOverflow.visible,
  BuildContext? context,
  bool softwrap = true,
  int? maxLines,
}) {
  if (msg == null) {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  } else {
    if (context != null && style != null) {
      var fontSize =
          style.fontSize ?? Theme.of(context).textTheme.bodyMedium!.fontSize;
      style = style.copyWith(
        fontSize: fontSize! - (context.width <= 375 ? 2 : 0),
      );
    }
    return Text(
      msg,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softwrap,
      key: key,
      maxLines: maxLines,
    );
  }
}

Widget customIconText(
    {required IconData iconData,
    double? iconSize,
    double? iconPadding,
    double? textSize,
    required String text,
    Color? color}) {
  return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
    customIcon(
        icon: iconData,
        size: iconSize ?? 13,
        paddingIcon: iconPadding ?? 3,
        iconColor: color ?? AppColor.darkGrey),
    const SizedBox(width: 2),
    customText(
      text,
      style: TextStyle(
          color: color ?? AppColor.darkGrey, fontSize: textSize ?? 13),
    ),
  ]);
}

SnackBar customSnackbar({
  required String msg,
  int duration = 3,
  bool btnAdded = false,
  String? btnName,
  Function? buttonPressd,
}) {
  return SnackBar(
      content: Text(msg), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: Duration(seconds: duration), //올라와있는 시간
      action: btnAdded
          ? null
          : SnackBarAction(
              //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
              label: btnName ?? '', //버튼이름
              onPressed: () {
                buttonPressd;
              }, //버튼 눌렀을때.
            ));
}

Widget loader() {
  if (Platform.isIOS) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  } else {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}
