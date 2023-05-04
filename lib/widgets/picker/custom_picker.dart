import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/helper/utility.dart';

import 'package:flutter/cupertino.dart';

class CustomPicker {
  CustomPicker({
    Key? key,
    required this.targetContext,
    required this.onItemSelected,
    required this.itemList,
  });

  final BuildContext targetContext;
  final Function(dynamic item) onItemSelected;
  List<String> itemList;

  set itemLst(List<String> _itemList) {
    itemList = _itemList;
  }

  Future<dynamic> openPicker() {
    // 초기 셋팅 (아이템리스트의 첫번재 항목)
    dynamic pickItem = itemList[0];

    return showCupertinoModalPopup(
      context: targetContext,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: AppColor.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: CustomFlatButton(
                  onPressed: () {
                    onItemSelected(pickItem);
                    Navigator.of(context).pop();
                  },
                  label: '선택',
                  borderRadius: 0,
                  padding: const EdgeInsets.all(15),
                  color: HongsiColor.persimmon,
                ),
              ),
              SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    magnification: 1.2,
                    onSelectedItemChanged: (index) {
                      pickItem = itemList[index];
                      Utility.debugLog(pickItem);
                    },
                    itemExtent: 50.0,
                    children:
                        List<Widget>.generate(itemList.length, (int index) {
                      return Center(
                        child: Expanded(
                          child: customText(
                            itemList[index],
                          ),
                        ),
                      );
                    }),
                  )),
            ],
          ),
        );
      },
    );
  }
}
