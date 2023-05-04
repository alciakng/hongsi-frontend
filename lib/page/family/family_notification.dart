import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hongsi_project/helper/constant.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/notify_model.dart';
import 'package:hongsi_project/theme/theme.dart';

// [state,model]
import 'package:hongsi_project/state/family_state.dart';
import 'package:hongsi_project/widgets/button/circle_button.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';

// [provider]
import 'package:provider/provider.dart';

// [notification Tile]
import 'package:hongsi_project/page/family/common/notification_tile.dart';
import 'package:hongsi_project/widgets/picker/custom_action_picker.dart';

// [persistent header]
import 'package:hongsi_project/widgets/sliver/sliver_persistent_delegate.dart';

class FamilyNotification extends StatefulWidget {
  const FamilyNotification({Key? key}) : super(key: key);

  @override
  State<FamilyNotification> createState() => _FamilyNotificationState();
}

class _FamilyNotificationState extends State<FamilyNotification> {
  final List<bool> _selectedTypes = <bool>[true, false];

  // familyActionPicker
  late CustomActionPicker _notificationActionPicker;

  late StreamSubscription familyListener;
  late StreamSubscription notificationListener;

  // type Button List
  List<bool> typeIsSelected = [];

  @override
  void initState() {
    super.initState();

    // familyState => 가족정보를 관리한다.
    final familyState = Provider.of<FamilyState>(context, listen: false);

    // Custom Action Picker
    _notificationActionPicker = CustomActionPicker(targetContext: context);

    // 알림정보를 가져온다. (처음에 셋팅된)
    familyState.getNotifications();

    // type 개수만큼 typeIsSelected 셋팅한다.
    NotificationType.values.forEach((element) {
      if (element == NotificationType.ALL) {
        typeIsSelected.add(true);
      } else {
        typeIsSelected.add(false);
      }
    });

    // family collection에 리스너를 붙인다.
    /*
    final familyRef = firestore.collection('family').doc(familyState.id);

    familyListener = familyRef
        .snapshots()
        .listen((data) => familyState.onChangeFamily(data));
    */

    // notification collection에 리스너를 붙인다.
    /*
    final notificationRef = firestore
        .collection('family')
        .doc(familyState.id)
        .collection('notification');

    notificationListener = notificationRef
        .snapshots()
        .listen((data) => familyState.onChangeNotification(data.docChanges));
    */
  }

  @override
  void dispose() {
    familyListener.cancel();
    notificationListener.cancel();
    super.dispose();
  }

  Widget _typeButton(FamilyState familyState) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverPersistentDelegate(
        maxHeight: 65,
        minHeight: 65,
        child: Container(
          color: AppColor.white,
          alignment: Alignment.center,
          height: 65,
          width: context.width,
          padding: EdgeInsets.only(bottom: 10),
          child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: ((context, index) {
                return SizedBox(
                  width: 15,
                );
              }),
              itemBuilder: ((context, index) {
                int? BadgeCnt;

                switch (NotificationType.values[index]) {
                  case NotificationType.ALL:
                    BadgeCnt = familyState.familyModel!.notificationCnt;
                    break;
                  case NotificationType.NORMAL:
                    BadgeCnt = familyState.familyModel!.normalCnt;
                    break;
                  case NotificationType.NEIGHBOR_REQUEST:
                    BadgeCnt = familyState.familyModel!.neighborRequestCnt;
                    break;
                  case NotificationType.FAMILY_REQEST:
                    BadgeCnt = familyState.familyModel!.familyRequestCnt;
                    break;
                  default:
                }

                Widget button = OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: typeIsSelected[index]
                          ? AppColor.persimmon
                          : AppColor.white,
                      primary: typeIsSelected[index]
                          ? AppColor.white
                          : AppColor.persimmon,
                      textStyle: typeIsSelected[index]
                          ? TextStyles.white16Bold
                          : TextStyles.persimmon16Bold),
                  child: customText(NotificationType.values[index].type),
                  onPressed: () {
                    setState(() {
                      for (int i = 0; i < typeIsSelected.length; i++) {
                        typeIsSelected[i] = i == index;
                      }
                    });
                  },
                );

                return button;
              }),
              itemCount: NotificationType.values.length),
        ),
      ),
    );
  }

  // 일반 알림
  Widget _verticalListView(NotificationType type) {
    final familyState = Provider.of<FamilyState>(context);

    // 알람
    late List<NotifyModel> notificationList = [];
    // 아이템수
    late int itemCount;

    switch (type) {
      case NotificationType.NORMAL:
        notificationList.addAll(familyState.normalRequestList);
        itemCount = familyState.normalRequestList.length;
        break;
      case NotificationType.NEIGHBOR_REQUEST:
        notificationList.addAll(familyState.neighborRequestList);
        itemCount = familyState.neighborRequestList.length;
        break;
      case NotificationType.FAMILY_REQEST:
        notificationList.addAll(familyState.familyRequestList);
        itemCount = familyState.familyRequestList.length;
        break;

      default:
    }

    return SliverToBoxAdapter(
      child: Column(
        children: itemCount == 0
            ? [
                SizedBox(
                  height: 20,
                ),
                customText(type.type + '이 없습니다.', style: TextStyles.noneBold16)
              ]
            : List.generate(
                itemCount,
                (index) => Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Material(
                        elevation: 4,
                        child: NotificationTile(
                          targetContext: context,
                          notification: notificationList[index],
                        ),
                      ),
                    )),
      ),
    );
  }

  // 가로리스트 알림
  Widget _hoirizontalListView(NotificationType type) {
    final familyState = Provider.of<FamilyState>(context);

    // 알람
    late List<NotifyModel> notificationList = [];
    // 아이템수
    late int itemCount;

    switch (type) {
      case NotificationType.NORMAL:
        notificationList.addAll(familyState.normalRequestList);
        itemCount = familyState.normalRequestList.length;
        break;
      case NotificationType.NEIGHBOR_REQUEST:
        notificationList.addAll(familyState.neighborRequestList);
        itemCount = familyState.neighborRequestList.length;
        break;
      case NotificationType.FAMILY_REQEST:
        notificationList.addAll(familyState.familyRequestList);
        itemCount = familyState.familyRequestList.length;
        break;

      default:
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        AppIcon.arrowForward,
                        color: AppColor.darkGreen,
                        size: 18,
                      ))
                ]),
          ),
          Container(
              alignment: Alignment.center,
              height: 100,
              width: context.width,
              child: itemCount == 0
                  ? customText(type.type + '이 없습니다.',
                      style: TextStyles.noneBold16)
                  : PageView(
                      controller: PageController(
                        viewportFraction: itemCount > 1
                            ? 0.88
                            : 1.0, // itemCount 가 1 이상인 경우 다음페이지가 보여지도록 함
                        initialPage: 0,
                      ),
                      padEnds: false,
                      scrollDirection: Axis.horizontal,
                      children: notificationList.map((notification) {
                        return NotificationTile(
                            targetContext: context, notification: notification);
                      }).toList(),
                    )),
        ],
      ),
    );

    /* 
    SliverList(
      // The items in this example are fixed to 48 pixels
      // high. This matches the Material Design spec for
      // ListTile widgets.
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        // This builder is called for each child.
        // In this example, we just number each list item.

        // divider 구현을 위하여  itemIndex 계산을 한다.
        final int itemIndex = index ~/ 2;
        if (index.isEven) {
          return NotificationTile(
              notificationActionPicker: _notificationActionPicker,
              notification: notificationList[index]);
        }
        return SizedBox(
          height: 5,
        );
      },
          // The childCount of the SliverChildBuilderDelegate
          // specifies how many children this inner list
          // has. In this example, each tab has a list of
          // exactly 30 items, but this is arbitrary.
          childCount: itemCount),
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    // familyState => 가족정보를 관리한다.
    final familyState = Provider.of<FamilyState>(context);

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            const SizedBox(width: 20),
          ],
        ),
        body: CustomScrollView(slivers: [
          _typeButton(familyState),
          if (typeIsSelected[NotificationType.ALL.num])
            _hoirizontalListView(NotificationType.NORMAL),
          if (typeIsSelected[NotificationType.ALL.num])
            _hoirizontalListView(NotificationType.NEIGHBOR_REQUEST),
          if (typeIsSelected[NotificationType.ALL.num])
            _hoirizontalListView(NotificationType.FAMILY_REQEST),
          if (!typeIsSelected[NotificationType.ALL.num])
            _verticalListView(NotificationType.getByNum(
                typeIsSelected.indexWhere((element) => element == true)))
        ]));
  }
}
