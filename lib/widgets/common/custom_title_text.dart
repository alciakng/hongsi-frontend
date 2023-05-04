import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final double lineSpacing;
  final double indent;

  const TitleText(this.text,
      {Key? key,
      this.fontSize = 18,
      this.color = Colors.black,
      this.fontWeight = FontWeight.w800,
      this.textAlign = TextAlign.left,
      this.overflow = TextOverflow.visible,
      this.lineSpacing = 2.0,
      this.indent = 0.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: indent),
        child: Text(
          text,
          style: GoogleFonts.gothicA1(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
              height: lineSpacing),
          textAlign: textAlign,
          overflow: overflow,
        ));
  }
}
