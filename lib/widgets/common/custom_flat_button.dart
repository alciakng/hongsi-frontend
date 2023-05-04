import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.isLoading,
      this.isValid = true,
      this.color,
      this.labelStyle,
      this.borderRadius = 6.0,
      this.whichBorder = "all",
      this.icon,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10)})
      : super(key: key);
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? labelStyle;
  final ValueNotifier<bool>? isLoading;
  final bool isValid;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final String whichBorder;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading ?? ValueNotifier(false),
      builder: (context, loading, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  padding: MaterialStateProperty.all(padding),
                  backgroundColor: MaterialStateProperty.all(isValid
                      ? color ?? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: whichBorder == "all" || whichBorder == "topLeft"
                          ? Radius.circular(borderRadius)
                          : Radius.zero,
                      topRight:
                          whichBorder == "all" || whichBorder == "topRight"
                              ? Radius.circular(borderRadius)
                              : Radius.zero,
                      bottomLeft:
                          whichBorder == "all" || whichBorder == "bottomLeft"
                              ? Radius.circular(borderRadius)
                              : Radius.zero,
                      bottomRight:
                          whichBorder == "all" || whichBorder == "bottomRight"
                              ? Radius.circular(borderRadius)
                              : Radius.zero,
                    )),
                  ),
                  overlayColor: MaterialStateProperty.all(
                      color ?? Theme.of(context).primaryColorDark),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onPressed: loading ? null : (isValid ? onPressed : null),
                child: loading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: FittedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(color ??
                                Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      )
                    : child!,
              ),
            ),
          ],
        );
      },
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: labelStyle ??
            GoogleFonts.mulish(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
