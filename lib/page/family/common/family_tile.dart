import 'package:flutter/material.dart';

// [helper]
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/helper/enum.dart';

// [state,model]
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/state/family_state.dart';

// [widget]
import 'package:hongsi_project/widgets/image/circular_image.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';

// [family custom]
import 'package:hongsi_project/widgets/picker/custom_action_picker.dart';

// [theme]
import 'package:hongsi_project/theme/theme.dart';
import 'package:provider/provider.dart';

class FamilyTile extends StatelessWidget {
  FamilyTile({Key? key, required this.familyActionPicker, required this.family})
      : super(key: key);

  final CustomActionPicker familyActionPicker;
  final FamilyModel family;

  @override
  Widget build(BuildContext context) {
    final familyState = Provider.of<FamilyState>(context);

    return ListTile(
        onTap: () {
          familyActionPicker.openActionPicker(
            type: PickerType.FAMILY_CHOOSE,
            model: family.toJson(),
          );
        },
        leading: CircularImage(path: family.familyImage, height: 40),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            customText(family.name, style: TextStyles.dark18Bold),
            SizedBox(
              width: 10,
            ),
            FutureBuilder(
              //future: familyState.isMyNeighbor(family.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return SizedBox(
                    height: 0,
                  );
                } else {
                  switch (snapshot.data) {
                    case NeighborState.SEND_REQUEST:
                      return const Icon(
                        AppIcon.circleArrowForward,
                        size: 20,
                        color: AppColor.lightGreen,
                      );
                    case NeighborState.RECEIVE_REQUEST:
                      return const Icon(
                        AppIcon.circleArrowBackward,
                        size: 20,
                        color: AppColor.lightGreen,
                      );
                    case NeighborState.APPROVE:
                      return const Icon(
                        AppIcon.myNeighbor,
                        size: 20,
                        color: AppColor.lightGreen,
                      );
                    default:
                      return SizedBox(
                        height: 0,
                      );
                  }
                }
              },
            ),
          ],
        ),
        subtitle: basicSubtitle(),
        tileColor: AppColor.white,
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0));
  }

  Widget basicSubtitle() {
    return Padding(
      padding:
          family.bio != '' ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (family.bio != '')
            Container(
                alignment: Alignment.centerLeft,
                child: customText(family.bio, maxLines: 2)),
          Divider(
            color: AppColor.lightGrey,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customText('이웃', style: TextStyles.lightGreen14Bold),
              SizedBox(
                width: 10,
              ),
              customText(family.neighborCnt.toString(),
                  style: TextStyles.noneBold13),
              SizedBox(
                width: 10,
              ),
              customText('관심', style: TextStyles.lightGreen14Bold),
              SizedBox(
                width: 10,
              ),
              customText(family.interestField, style: TextStyles.noneBold14),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customIconText(
                  iconData: AppIcon.person, text: family.userCnt.toString()),
              SizedBox(
                width: 5,
              ),
              customIconText(
                  iconData: AppIcon.locationPin,
                  text: (family.sido ?? '') + ' ' + (family.sigungu ?? '')),
            ],
          ),
        ],
      ),
    );
  }

  // search_page.dart의 이웃신청시 배지표시
  Widget neighborStateBadge(
      {required String text,
      required double width,
      Color color = AppColor.lightGreen,
      Color textColor = AppColor.white}) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color,
          border: Border.all(width: 1, color: color),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: customText(
            text,
            style: new TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
