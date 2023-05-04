import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.label,
    this.color = AppColor.darkGrey,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.mulish(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: color,
          ),
        ));
  }
}
