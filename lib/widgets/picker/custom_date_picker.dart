import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/helper/utility.dart';

import 'package:flutter/cupertino.dart';

class CustomDatePicker {
  const CustomDatePicker({
    Key? key,
    required this.targetContext,
    required this.onDateSelected,
  });

  final BuildContext targetContext;
  final Function(DateTime date) onDateSelected;

  Future<dynamic> openDatePicker() {
    DateTime pickDate = DateTime.now();

    return showModalBottomSheet(
      context: targetContext,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Expanded(
                child: CustomFlatButton(
                  onPressed: () {
                    onDateSelected(pickDate);
                    Navigator.of(context).pop();
                  },
                  label: '선택',
                  borderRadius: 0,
                  padding: EdgeInsets.all(15),
                  color: HongsiColor.persimmon,
                ),
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                    onDateTimeChanged: (datetime) {
                      pickDate = datetime;
                    },
                    minimumYear: 1900,
                    maximumYear: pickDate.year,
                    initialDateTime: pickDate,
                    dateOrder: DatePickerDateOrder.ymd,
                    mode: CupertinoDatePickerMode.date),
              )
            ],
          ),
        );
      },
    );
  }
}
