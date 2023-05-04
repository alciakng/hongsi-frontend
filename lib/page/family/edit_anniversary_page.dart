import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/common/custom_form_filed.dart';

import 'package:hongsi_project/widgets/picker/custom_date_picker.dart';

import 'common/validator.dart';

import 'package:intl/intl.dart';

class EditAnniversaryPage extends StatefulWidget {
  EditAnniversaryPage({Key? key, required this.onCompleted}) : super(key: key);

  final void Function(Map<String, dynamic>) onCompleted;

  /// 유효성 체크 모듈
  late ValidDelegate _validDelegate;

  @override
  State<StatefulWidget> createState() => _EditAnniversaryPage();
}

class _EditAnniversaryPage extends State<EditAnniversaryPage> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;

  //선택된 날짜
  late DateTime _selectDate;

  late CustomDatePicker _customDatePicker;

  @override
  void initState() {
    _nameController = TextEditingController();
    _dateController = TextEditingController();

    widget._validDelegate = ValidDelegate();

    // customDatePicker 정의, 날짜를 선택하면 datecontroller.text에 셋팅해준다.
    _customDatePicker = CustomDatePicker(
        targetContext: context,
        onDateSelected: (date) {
          // 선택된 날짜 셋팅
          _selectDate = date;
          // 표시날짜 셋팅
          _dateController.text = DateFormat('yyyy년 MM월 dd일').format(date);
          // 유효성 체크 및  setState(상태변경)
          setState(() {
            widget._validDelegate.dateValidator(date);
          });
        });

    super.initState();
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_anniversaryInput(context)],
    );
  }

  void _submitButton() {
    // edit_family_page로 콜백 (이름, 날짜)
    if (widget._validDelegate.anniversaryValid) {
      widget.onCompleted({
        'name': _nameController.text,
        'date': Timestamp.fromDate(_selectDate)
      });
      Navigator.of(context).pop();
    }
  }

  Widget _anniversaryInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomFormField(
            textEditingController: _nameController,
            onChanged: (val) {
              setState(() {
                widget._validDelegate.nameValidator(val);
              });
            },
            onEditingComplete: () {
              _customDatePicker.openDatePicker();
            },
            hintText: '기념일이름',
            guideText: '기념일을 입력해주세요',
            isEmail: false,
            isPassword: false,
            errorText: widget._validDelegate.nameErrorText,
          ),
          InkWell(
              onTap: () {
                _customDatePicker.openDatePicker();
              },
              child: IgnorePointer(
                // InkWell 미작동으로 인해 IgnorePointer 추가
                child: CustomFormField(
                  textEditingController: _dateController,
                  onChanged: (_) {},
                  hintText: '날짜를 선택해주세요',
                  isEmail: false,
                  isPassword: false,
                  errorText: widget._validDelegate.dateErrorText,
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text(
                '완료',
                style: widget._validDelegate.anniversaryValid
                    ? TextStyles.appbarEnableButtonText
                    : TextStyles.appbarDisalbeButtonText,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: _body(),
    );
  }
}
