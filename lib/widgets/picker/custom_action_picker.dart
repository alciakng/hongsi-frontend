import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/notify_model.dart';

import 'package:hongsi_project/model/user_model.dart';
import 'package:hongsi_project/state/notify_state.dart';

import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/state/family_state.dart';
import 'package:provider/provider.dart';

class CustomActionPicker {
  const CustomActionPicker({
    Key? key,
    required this.targetContext,
  });

  final BuildContext targetContext;

  /*
  Widget tweetOptionIcon(BuildContext context,
      {required FeedModel model,
      required TweetType type,
      required GlobalKey<ScaffoldState> scaffoldKey}) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: customIcon(context,
          icon: AppIcon.arrowDown,
          istwitterIcon: true,
          iconColor: AppColor.lightGrey),
    ).ripple(
      () {
        _openbottomSheet(context,
            type: type, model: model, scaffoldKey: scaffoldKey);
      },
      borderRadius: BorderRadius.circular(20),
    );
  }
  */

  void openActionPicker(
      {required PickerType type, required Map<dynamic, dynamic> model}) async {
    var authState = Provider.of<AuthState>(targetContext, listen: false);
    var familyState = Provider.of<FamilyState>(targetContext, listen: false);

    FamilyModel? _familyModel;
    UserModel? _userModel;
    NotifyModel? _notifyModel;

    Widget? option;

    bool? isMine;
    // 이웃상태
    NeighborState? neighborState;

    /*
      [FAMILY_CHOOSE] 가족검색 화면에서 가족을 선택했을때 동작
      [USER_CHOOSE] 가족검색 화면에서 유저를 선택했을때 동작 
      [NEIGHBOR_REQUEST] 알람화면에서 가족을 선택했을때 동작 
      [FAMILY_REQUEST] 가족구성원으로 요청했을때 동작 
    */
    if (type == PickerType.FAMILY_CHOOSE) {
      _familyModel = FamilyModel.fromJson(model);

      // 이웃인지 여부 체크
      //neighborState = await familyState.isMyNeighbor(_familyModel.id);
      isMine = familyState.familyModel?.id == _familyModel.id;

      // 옵션셋팅
      /*
      option = _familyOptions(
        isMine: isMine,
        neighborState: neighborState,
        model: _familyModel,
      );
      */
    } else if (type == PickerType.NEIGHBOR_REQUEST) {
      _notifyModel = NotifyModel.fromJson(model);

      // 옵션셋팅
      option = _neighborRequestOptios(model: _notifyModel);
    } else {
      _userModel = UserModel.fromJson(model);
      isMine = authState.userModel?.uid == _userModel.uid;
    }

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: targetContext,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: context.height *
                (type == PickerType.FAMILY_CHOOSE
                    ? ((isMine ?? false) ? .15 : .15)
                    : ((isMine ?? false) ? .15 : .15)),
            width: context.width,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
            ),
            child: option);
      },
    );
  }

  Widget _neighborRequestOptios({required NotifyModel model}) {
    return Column(
      children: <Widget>[
        _widgetBottomSheetRow(AppIcon.person,
            text: '이웃승인', onPressed: () async {}),
        _widgetBottomSheetRow(AppIcon.info,
            text: '이웃거절', isAlert: false, onPressed: () async {}),
      ],
    );
  }

  Widget _familyOptions(
      {required bool isMine,
      required NeighborState neighborState,
      required FamilyModel model}) {
    var familyState = Provider.of<FamilyState>(targetContext, listen: false);

    late String requestButtonText;
    late bool isAlert;
    late String msg;

    if (neighborState == NeighborState.SEND_REQUEST) {
      requestButtonText = '이웃요청 취소';
      msg = '이웃신청이 철회되었습니다.';
      isAlert = true;
    } else if (neighborState == NeighborState.APPROVE) {
      requestButtonText = '이웃해제';
      msg = '이웃해제 되었습니다.';
      isAlert = true;
    } else {
      requestButtonText = '이웃신청';
      msg = '이웃신청되었습니다. 상대방이 승인하면 이웃이됩니다.';
      isAlert = false;
    }

    return Column(
      children: <Widget>[
        if (!isMine)
          _widgetBottomSheetRow(AppIcon.person,
              text: requestButtonText, isAlert: isAlert, onPressed: () async {
            Navigator.of(targetContext).pop();

            if (familyState.id == null) {
              ScaffoldMessenger.of(targetContext).showSnackBar(SnackBar(
                backgroundColor: HongsiColor.persimmon,
                content: customText(
                  '가족을 먼저 생성해주세요.',
                  style: TextStyles.white16Bold,
                ),
              ));
              return;
            }
            // 알람
            late Map<String, dynamic> notification;
            // 알람타입
            late NotificationType type;

            if (neighborState == NeighborState.NONE) {
              // 알람타입 - 이웃신청
              type = NotificationType.NEIGHBOR_REQUEST;
            } else {
              // 알람타입 - 일반
              type = NotificationType.NORMAL;
            }

            // 타입에 따른 행동분기
            showRequestModal(type, (String? message) async {
              switch (type) {
                case NotificationType.NEIGHBOR_REQUEST:
                  // 신청한 유저의 neighbor subCollection의 Document를 생성한다.
                  var neighborId = await familyState.createNeighbor(model);
                  // 상대방에게 보내질 알람정보
                  notification = {
                    "neighborId":
                        neighborId!, // 상대방이 승인하거나, 거절하였을때 신청자의 neighbor Subcollection 을 참조하기 위한 용도임
                    "model": familyState.familyModel!.toJson(),
                  };

                  break;
                case NotificationType.NORMAL:
                  // 이웃삭제
                  await familyState.deleteNeighbor(model.id!);
                  // 상대방에게 보내질 알람정보
                  notification = {
                    "model": familyState.familyModel!.toJson(),
                  };
                  break;
                default:
              }

              // nofityModel (알람정보)
              NotifyModel notifyModel = NotifyModel(
                type: type.name, // 알림종류
                notification: notification,
                createdAt: DateTime.now().toUtc().toString(),
                message: message,
              );

              // 알람을 발송한다.
              await familyState.createNotification(
                to: model.id!,
                notifyModel: notifyModel,
              );
            });
          }),
        if (!isMine)
          _widgetBottomSheetRow(AppIcon.info,
              text: '가족정보', isAlert: false, onPressed: () async {}),
      ],
    );
  }

  Widget _widgetBottomSheetRow(IconData icon,
      {required String text, Function? onPressed, bool isAlert = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Row(
          children: <Widget>[
            customIcon(
              icon: icon,
              size: 25,
              paddingIcon: 2,
              iconColor: isAlert ? AppColor.ceriseRed : AppColor.lightGreen,
            ),
            const SizedBox(
              width: 15,
            ),
            customText(
              text,
              context: targetContext,
              style: TextStyle(
                color: isAlert ? AppColor.ceriseRed : AppColor.secondary,
                fontSize: 18,
                fontWeight: isAlert ? FontWeight.w800 : FontWeight.w400,
              ),
            )
          ],
        ),
      ).ripple(() {
        if (onPressed != null) {
          onPressed();
        } else {
          Navigator.pop(targetContext);
        }
      }),
    );
  }

  showRequestModal(NotificationType type, Function callback) {
    Widget? title;
    Widget? content;

    TextEditingController _message = TextEditingController();

    // 타입에 따른 분기
    switch (type) {
      case NotificationType.NEIGHBOR_REQUEST:
        title = customText('이웃요청', style: TextStyles.persimmon18Bold);
        content = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: _message,
            maxLength: 100,
            maxLines: null,
            decoration: InputDecoration(hintText: '안녕하세요. 이웃신청을 받아주세요.'),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        );
        break;
      case NotificationType.NORMAL:
        title = customText('이웃취소/해제', style: TextStyles.persimmon18Bold);
        content = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: customText('정말 이웃취소/해제하시겠습니까?', style: TextStyles.noneBold16),
        );
        break;
      default:
    }

    return showDialog(
        context: targetContext,
        builder: (BuildContext context) {
          return AlertDialog(
              title: title,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  content!,
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomFlatButton(
                            label: '닫기',
                            color: AppColor.lightGrey,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            borderRadius: 0.0,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomFlatButton(
                            label: '확인',
                            color: HongsiColor.persimmon,
                            onPressed: () {
                              Navigator.pop(context);
                              callback(_message.text);
                            },
                            borderRadius: 0.0,
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))));
        });
  }
}
