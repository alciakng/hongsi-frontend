import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

// [badge]
import 'package:badges/badges.dart';

import 'package:hongsi_project/page/family/common/family_tile.dart';

// [state,model]
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/state/family_state.dart';
import 'package:hongsi_project/state/search_state.dart';

// [helper]
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/helper/enum.dart';

// [widget]
import 'package:hongsi_project/widgets/urlText/custom_url_text.dart';
import 'package:hongsi_project/widgets/common/custom_title_text.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/widgets/image/circular_image.dart';
import 'package:hongsi_project/widgets/button/ripple_button.dart';
import 'package:hongsi_project/widgets/image/cache_image.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:hongsi_project/widgets/button/circle_button.dart';

// [persistent header]
import 'package:hongsi_project/widgets/sliver/sliver_persistent_delegate.dart';

// [picker]
import 'package:hongsi_project/widgets/picker/custom_action_picker.dart';

// [theme]
import 'package:hongsi_project/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:hongsi_project/model/user_model.dart';

// [router]
import 'package:hongsi_project/routes/route_manager.dart' show RouteManager;
import 'package:hongsi_project/routes/route_path.dart';

class SearchFamily extends StatefulWidget {
  const SearchFamily({Key? key}) : super(key: key);

  @override
  State<SearchFamily> createState() => _SearchFamilyState();
}

class _SearchFamilyState extends State<SearchFamily>
    with SingleTickerProviderStateMixin {
  TextEditingController editingController = TextEditingController();

  // 탭종류
  static const List<Tab> tabs = <Tab>[
    Tab(text: '가족찾기'),
    Tab(text: '홍시찾기'),
  ];

  // 탭컨트롤러, 스크롤컨트롤러(동적으로 리스트를 불러오기 위함)
  late TabController _tabController;
  late ScrollController _scrollController;

  // familyActionPicker
  late CustomActionPicker _familyActionPicker;

  @override
  void initState() {
    super.initState();

    // authState => 유저정보를 관리한다.
    final authState = Provider.of<AuthState>(context, listen: false);
    // familyState => 가족정보를 관리한다.
    final familyState = Provider.of<FamilyState>(context, listen: false);
    // searchState => 홍시가족 및 홍시들 검색결과를 관리한다.
    final searchState = Provider.of<SearchState>(context, listen: false);

    // tabController, scrollController
    _tabController = TabController(vsync: this, length: tabs.length);
    _scrollController = ScrollController();

    // Custom Action Picker
    _familyActionPicker = CustomActionPicker(targetContext: context);

    // 탭 바뀔때마다 setState 호출
    _tabController.addListener(() {
      setState(() {});
    });

    // 가족정보를 가져온다.
    familyState.getFamily(authState.userModel!.famId);
    // 최초 1회 홍시가족 및 홍시 검색결과를 가져온다. (개수제한)
    // [todo] 메인페이지로 이동
    searchState.getFamilys();
    searchState.getDocuments();

    /* Nested ScrollView 에서는 먹히지 않음 => NotificationListener로 구현 
    // 스크롤이 올라갈때마다 추가 검색결과를 가져온다.
    _scrollController.addListener(() {
      // 스크롤이 끝에 도달하였을 시
      if (_scrollController.position.atEdge) {
        //최상단
        if (_scrollController.position.pixels == 0) {
          print('ListView scroll at top');
        }
        //최하단일때 추가 검색결과를 가져온다.
        else if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          print('ListView scroll at bottom');

          _tabController.index == 0
              ? searchState.getFamilysNext() // 가족 추가검색결과
              : searchState.getDocumentsNext(); // 유저 추가검색결과
        }
      }
    });
    */
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget defaultBar() {
    final familyState = Provider.of<FamilyState>(context);

    return Container(
        color: AppColor.white,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TitleText(
              '새로운 가족을 만들고,\n홍시들을 초대해보세요',
              fontSize: 23,
              fontWeight: FontWeight.w300,
              lineSpacing: 1.5,
              indent: 5.0,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomFlatButton(
                label: "홍시가족 만들기",
                color: HongsiColor.persimmon,
                isLoading: ValueNotifier(false),
                onPressed: () {
                  Utility.logEvent("button Onpressed");
                  Provider.of<RouteManager>(context, listen: false).push(
                      RoutePath.otherPage(RouteName.EDIT_FAMILY, args: () {
                    setState(() {
                      familyState.getFamily(familyState.id);
                    });
                  }));
                },
                borderRadius: 2,
              ),
            ),
          ],
        ));
  }

  Widget familyBar(FamilyState familyState) {
    return Container(
      color: AppColor.white,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          // Container(height: 50, color: Colors.black),
          /// 배너이미지
          Container(
            alignment: Alignment.topCenter,
            height: 180,
            child: CacheImage(
              path: familyState.familyModel!.bannerImage ??
                  'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
              fit: BoxFit.fill,
            ),
          ),

          /// 패밀리 프로필이미지,
          Container(
            padding: const EdgeInsets.only(right: 10),
            height: 230,
            alignment: Alignment.bottomLeft,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        shape: BoxShape.circle),
                    child: RippleButton(
                      child: CircularImage(
                        path: familyState.familyModel!.familyImage,
                        height: 90,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      onPressed: () {},
                    ),
                  ),
                  Wrap(
                    children: [
                      CircleButton(
                        iconData: AppIcon.notification,
                        onPressed: () {
                          Provider.of<RouteManager>(context, listen: false)
                              .push(RoutePath.otherPage(
                                  RouteName.FAMILY_NOTIFICATION));
                        },
                      ),
                      CircleButton(iconData: AppIcon.addPerson),
                      CircleButton(
                        iconData: AppIcon.settings,
                        onPressed: () {
                          Provider.of<RouteManager>(context, listen: false)
                              .push(RoutePath.otherPage(RouteName.EDIT_FAMILY,
                                  args: () {
                            setState(() {});
                          }));
                        },
                      ),
                    ],
                  )
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // searchFamilyState => 홍시가족 검색결과 및 홍시 검색결과
    final searchState = Provider.of<SearchState>(context);
    final familyState = Provider.of<FamilyState>(context);

    /*
    // 가족여부에 앱바 셋팅
    if (familyState.id == null) {
      flexibleSpaceBar = defaultBar();
      flexibleBarHeight = 320;
    } else {
      flexibleSpaceBar = familyBar(familyState);

      if (Utility.getTextLine(
              text: familyState.familyModel!.bio,
              style: TextStyles.noneBold14) ==
          0) {
        flexibleBarHeight = 330;
      } else {
        flexibleBarHeight = 380;
      }
    }
    */

    return DefaultTabController(
        length: tabs.length, // This is the number of tabs.
        child: Scaffold(
            appBar: AppBar(),
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  // These are the slivers that show up in the "outer" scroll view.
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: familyState.id == null
                          ? defaultBar()
                          : familyBar(familyState),
                    ),

                    // 고정헤더(검색가이드)
                    /*
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          minHeight: _tabController.index == 0 ? 55.0 : 40.0,
                          maxHeight: _tabController.index == 0 ? 55.0 : 40.0,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 10, bottom: 15),
                            color: AppColor.white,
                            child: TitleText(
                              _tabController.index == 0
                                  ? '홍시가족 구성원으로 가입 신청하거나,\n다른 가족들에게 이웃신청을 해보세요!'
                                  : '홍시들을 찾아 가족 구성원으로 초대해보세요!',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              lineSpacing: 1.5,
                              color: AppColor.darkGrey,
                              indent: 10.0,
                            ),
                          ),
                        )),
                        */
                    if (familyState.familyModel != null)
                      SliverToBoxAdapter(
                        child: Container(
                          color: AppColor.white,
                          alignment: Alignment.bottomLeft,
                          child: FamilyInfoWidget(
                            family: familyState.familyModel!,
                          ),
                        ),
                      ),

                    SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverPersistentDelegate(
                          minHeight: 50,
                          maxHeight: 50,
                          child: Container(
                            color: AppColor.white,
                            child: TabBar(
                                controller:
                                    _tabController, // These are the widgets to put in each tab in the tab bar.
                                tabs: tabs),
                          ),
                        )),

                    // 고정헤더 (검색 창)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverPersistentDelegate(
                          minHeight: 70.0,
                          maxHeight: 70.0,
                          child: Column(children: [
                            Container(
                              height: 70,
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 10),
                              color: AppColor.white,
                              child: TextField(
                                  controller: editingController,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: _tabController.index == 0
                                          ? '가족명으로 검색하세요'
                                          : '유저 닉네임으로 검색하세요',
                                      suffixIcon: IconButton(
                                        icon: const Icon(AppIcon.search),
                                        onPressed: () {
                                          var keyword = editingController.text;
                                          log(keyword);
                                          searchState.searchFamily(keyword);
                                        },
                                      ),
                                      contentPadding: EdgeInsets.all(13),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor.lightGrey,
                                              width: 0.5))),
                                  textAlign: TextAlign.justify,
                                  textAlignVertical: TextAlignVertical.bottom),
                            ),
                          ])),
                    )
                  ];
                },
                // 탭뷰
                body: TabBarView(
                    // These are the contents of the tab views, below the tabs.
                    controller: _tabController,
                    children: [
                      // 가족검색화면
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          builder: (BuildContext context) {
                            return NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is ScrollEndNotification) {
                                    if (notification.metrics.pixels ==
                                        notification.metrics.maxScrollExtent) {
                                      searchState.getFamilysNext(); //가족 추가검색결과
                                      return true;
                                    }
                                  }
                                  return true;
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                        searchState.familyList.length,
                                        (index) => Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Material(
                                                elevation: 4,
                                                child: FamilyTile(
                                                    familyActionPicker:
                                                        _familyActionPicker,
                                                    family: searchState
                                                        .familyList[index]),
                                              ),
                                            )),
                                  ),
                                ));
                          },
                        ),
                      ),
                      // 유저검색화면
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          builder: (BuildContext context) {
                            return NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is ScrollEndNotification) {
                                    if (notification.metrics.pixels ==
                                        notification.metrics.maxScrollExtent) {
                                      searchState
                                          .getDocumentsNext(); // 유저 추가검색결과
                                      return true;
                                    }
                                  }
                                  return true;
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                        searchState.userList.length,
                                        (index) => Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Material(
                                                elevation: 4,
                                                child: _UserTile(
                                                    user: searchState
                                                        .userList[index]),
                                              ),
                                            )),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ]))));
  }
}

/*----------------------------------------------------------------
  - 클래스 : _UserTile
  - 기능  : 유저타일 디자인
  - @param {} 
  - @return {} 
  - 이력 : 2022.08.03 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/
class _UserTile extends StatelessWidget {
  const _UserTile({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircularImage(path: user.profilePicPath, height: 40),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: TitleText(user.username!,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 3),
          ],
        ),
        subtitle: Text(user.username!),
        tileColor: AppColor.white,
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0));
  }
}

class FamilyInfoWidget extends StatelessWidget {
  const FamilyInfoWidget({
    Key? key,
    required this.family,
  }) : super(key: key);

  final FamilyModel family;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UrlText(text: family.name, style: TextStyles.dark20Bold),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customIconText(
                    iconSize: 15,
                    iconData: AppIcon.person,
                    textSize: 16,
                    text: family.userCnt.toString()),
                const SizedBox(
                  width: 5,
                ),
                customIconText(
                    iconSize: 15,
                    iconData: AppIcon.locationPin,
                    textSize: 14,
                    text: (family.sido ?? '') + ' ' + (family.sigungu ?? '')),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 11, top: 5, bottom: 5),
            child: Row(
              children: [
                customText('관심', style: TextStyles.lightGreen16Bold),
                SizedBox(
                  width: 10,
                ),
                customText(family.interestField, style: TextStyles.noneBold16),
                SizedBox(
                  width: 10,
                ),
                customText('이웃', style: TextStyles.lightGreen16Bold),
                SizedBox(
                  width: 10,
                ),
                customText(
                  family.neighborCnt.toString(),
                  style: TextStyles.noneBold16,
                )
              ],
            ),
          ),
          if (family.bio != '')
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 11, top: 10, right: 11),
              child: customText(family.bio,
                  maxLines: 2, style: TextStyles.noneBold14),
            ),
        ],
      ),
    );
  }
}
