import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'custom_widgets.dart';

import 'package:hongsi_project/theme/theme.dart';
import 'package:provider/provider.dart';

import 'package:hongsi_project/state/auth_state.dart';

import 'package:hongsi_project/helper/utility.dart';

class CustomFormField extends StatefulWidget {
  CustomFormField(
      {Key? key,
      required this.textEditingController,
      this.inputFormatters,
      required this.onChanged,
      this.onEditingComplete,
      required this.hintText,
      this.guideText,
      this.errorText,
      required this.isEmail,
      required this.isPassword,
      this.textInputAction = TextInputAction.done})
      : super(key: key);

  final String hintText;
  final String? guideText;
  final String? errorText;
  final TextEditingController textEditingController;
  final List<TextInputFormatter>? inputFormatters;

  final void Function(String) onChanged;
  final bool isEmail;
  final bool isPassword;

  final TextInputAction textInputAction;
  final Function()? onEditingComplete;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  // Widget 의 focus 여부를 판단하기 위함
  late final FocusNode _focusNode;

  bool _isInputed = false;

  @override
  void initState() {
    _focusNode = FocusNode();

    widget.textEditingController.addListener(() {
      if (widget.textEditingController.text != null) {
        _isInputed = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.guideText != null)
        customText(widget.guideText, style: TextStyles.subtitleStyle),
      if (widget.guideText != null)
        const SizedBox(
          height: 25,
        ),
      TextFormField(
        focusNode: _focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.textEditingController,
        inputFormatters: widget.inputFormatters,
        onChanged: (val) => {widget.onChanged(val)},
        keyboardType:
            widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: widget.isPassword,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: (widget.errorText == null &&
                    (_focusNode.hasFocus || _isInputed))
                // 유효한경우 체크 서클(그린)
                ? const Icon(Icons.check_circle, color: AppColor.lightGreen)
                // 유효하지 않으나, 포커스 되거나 값이 입력된 경우
                : (_focusNode.hasFocus || _isInputed)
                    ? const Icon(
                        Icons.error,
                        color: AppColor.ceriseRed,
                      )
                    : null,
            // 텍스트 폼 필드를 선택했을때
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    // 유효한 값이 들어간경우
                    color: (widget.errorText == null && (_isInputed))
                        ? HongsiColor.lightGreen
                        : HongsiColor.persimmon,
                    width: 1.5)),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: HongsiColor.ceriseRed, width: 1.5)),
            errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: HongsiColor.ceriseRed, width: 1.5)),
            // 텍스트 폼 필드를 선택하지 않았을때
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    // 에러가 아니고 AND (focus된 상태이거나 값이 들어갔을때 )
                    color: (widget.errorText == null &&
                            (_focusNode.hasFocus || _isInputed))
                        ? HongsiColor.lightGreen
                        : AppColor.lightGrey,
                    // focus 된 상태이거나 값이 들어간경우
                    width: (_focusNode.hasFocus || _isInputed) ? 1.5 : 0.8)),
            errorText: widget.errorText),
      )
    ]);
  }
}
