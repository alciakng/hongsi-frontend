import 'package:flutter/material.dart';

// [helper]
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/model/notify_model.dart';
import 'package:hongsi_project/model/user_model.dart';
import 'package:hongsi_project/helper/utility.dart';

// [state,model]
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/state/family_state.dart';

// [widget]
import 'package:hongsi_project/widgets/image/circular_image.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';

// [theme]
import 'package:hongsi_project/theme/theme.dart';
import 'package:provider/provider.dart';

class NotificationTile extends StatelessWidget {
  NotificationTile(
      {Key? key, required this.targetContext, required this.notification})
      : super(key: key);

  final BuildContext targetContext;
  final NotifyModel notification;

  @override
  Widget build(BuildContext context) {
    final familyState = Provider.of<FamilyState>(context);

    String? imagePath;
    String? name;

    FamilyModel? _familyModel;
    UserModel? _userModel;
    Map<String, dynamic>? _normalModel;

    NotificationType notificationType =
        NotificationType.getByName(notification.type);

    switch (notificationType) {
      case NotificationType.NEIGHBOR_REQUEST:
        // 이웃요청인 경우
        _familyModel = FamilyModel.fromJson(notification.notification['model']);
        // 이미지 설정
        imagePath = _familyModel.familyImage;
        name = _familyModel.name;
        break;
      case NotificationType.FAMILY_REQEST:
        // 가족요청인 경우
        _userModel = UserModel.fromJson(notification.notification['model']);
        // 이미지 설정
        imagePath = _userModel.profilePicPath;
        name = _userModel.username;
        break;
      case NotificationType.NORMAL:
        // 일반요청인 경우
        _normalModel = notification.notification['model'];
        name = _normalModel!['name'];
        imagePath = _normalModel['imagePath'];
        break;
      default:
    }

    return Container(
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 0,
        child: ListTile(
          onTap: () {
            if (notificationType == NotificationType.NORMAL) {
              // 일반요청인 경우
              if (_normalModel!['url'] != null) {
                // 해당 페이지로 이동
              } else {
                // 해당 알람 삭제
                familyState.deleteNotification(notifyModel: notification);
              }
            } else {
              // 그외 요청인경우
              showRequestModal();
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          leading: CircularImage(path: imagePath, height: 40),
          title: customText(name, style: TextStyles.dark18Bold),
          subtitle: _subtitle(),
          tileColor: AppColor.white,
          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
        ),
      ),
    );
  }

  // 가족요청인 경우 widget
  Widget _subtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: AppColor.lightGrey,
        ),
        customText(notification.message, maxLines: 2),
      ],
    );
  }

  // 승인, 거절 모달을 띄운다.
  showRequestModal() {
    Widget? title;
    Widget? content;

    final familyState = Provider.of<FamilyState>(targetContext, listen: false);

    FamilyModel? _familyModel;
    UserModel? _userModel;

    TextEditingController _message = TextEditingController();

    NotificationType notificationType =
        NotificationType.getByName(notification.type);

    // 타입에 따른 변수 설정
    if (notificationType == NotificationType.NEIGHBOR_REQUEST) {
      _familyModel = FamilyModel.fromJson(notification.notification['model']);
    }

    // 타입에 따른 분기
    switch (notificationType) {
      case NotificationType.NEIGHBOR_REQUEST:
        title = customText('이웃요청', style: TextStyles.persimmon18Bold);
        content = Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10),
                  child: customText(notification.message)),
              Divider(
                thickness: 1,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child:
                      customText('답장메시지', style: TextStyles.persimmon18Bold)),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  scrollPadding: EdgeInsets.all(0),
                  controller: _message,
                  maxLength: 100,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ],
          ),
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
                          child: TextButton(
                            child:
                                customText('거절', style: TextStyles.white14Bold),
                            onPressed: () {
                              switch (notification.type) {
                                // 이웃요청 알림인경우
                                case 'NEIGHBOR_REQUEST':
                                  // 이웃삭제
                                  familyState.deleteNeighbor(_familyModel!.id!);
                                  // 알림삭제
                                  familyState.deleteNotification(
                                      notifyModel: notification);

                                  // nofityModel (알람정보) -- 거절 메시지
                                  NotifyModel notifyModel = NotifyModel(
                                    type: NotificationType.NORMAL.name, // 알림종류
                                    notification: {
                                      "model":
                                          familyState.familyModel!.toJson(),
                                    },
                                    createdAt:
                                        DateTime.now().toUtc().toString(),
                                    message: _message.text,
                                  );

                                  // 알림발송
                                  familyState.createNotification(
                                      to: _familyModel.id!,
                                      notifyModel: notification);
                                  break;
                              }
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6.0))),
                              backgroundColor: AppColor.lightGrey,
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child:
                                customText('승인', style: TextStyles.white14Bold),
                            onPressed: () {
                              switch (notification.type) {
                                // 이웃요청 알림인경우
                                case 'NEIGHBOR_REQUEST':

                                  // [todo] atomic transaction
                                  // 이웃상태변경
                                  familyState.updateNeighbor(
                                      _familyModel!.id!, NeighborState.APPROVE);

                                  // 알림삭제
                                  familyState.deleteNotification(
                                      notifyModel: notification);

                                  // nofityModel (알람정보) -- 승낙 메시지
                                  NotifyModel approveNotifyModel = NotifyModel(
                                    type: NotificationType.NORMAL.name, // 알림종류
                                    notification: {
                                      "model":
                                          familyState.familyModel!.toJson(),
                                    },
                                    createdAt:
                                        DateTime.now().toUtc().toString(),
                                    message: _message.text,
                                  );

                                  // 알림발송
                                  familyState.createNotification(
                                      to: _familyModel.id!,
                                      notifyModel: approveNotifyModel);

                                  break;
                              }
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(6.0))),
                              backgroundColor: AppColor.persimmon,
                            ),
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
                  borderRadius: BorderRadius.all(Radius.circular(6.0))));
        });
  }
}
