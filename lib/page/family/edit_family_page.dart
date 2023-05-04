import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hongsi_project/helper/customRoute.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/family_model.dart';
import 'package:hongsi_project/routes/route_manager.dart';
import 'package:hongsi_project/routes/route_path.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/image/cache_image.dart';
import 'package:hongsi_project/widgets/image/circular_image.dart';

import 'package:provider/provider.dart';

import 'package:hongsi_project/state/family_state.dart';

import 'package:hongsi_project/helper/constant.dart';

// [custom widget]
import 'package:hongsi_project/widgets/picker/custom_image_picker.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:hongsi_project/widgets/picker/custom_picker.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';

// [date format]
import 'package:intl/intl.dart';

enum ImageType { BANNER, PROFILE }

class EditFamilyPage extends StatefulWidget {
  EditFamilyPage({Key? key, required this.onCompleted}) : super(key: key);

  final void Function() onCompleted;

  @override
  _EditFamilyPage createState() => _EditFamilyPage();
}

class _EditFamilyPage extends State<EditFamilyPage> {
  File? _familyImage;
  File? _familyBanner;

  // custom Loader
  late CustomLoader loader;

  // ImageType
  late ImageType _imageType;

  // Image, Banner Picker
  late CustomImagePicker _imagePicker;
  late CustomImagePicker _bannerPicker;
  // 지역, 관심사항 Picker
  late CustomPicker _sidoPicker;
  late CustomPicker _sigunguPicker;
  late CustomPicker _interestFieldPicker;

  // 기념일리스트
  List<Map<String, dynamic>> _anniversarys = [];
  // 기념일 타일 확장여부
  bool _anniversaryTileExpanded = false;

  late TextEditingController _name;
  late TextEditingController _bio;
  late TextEditingController _sido;
  late TextEditingController _sigungu;
  late TextEditingController _interestField;

  late GlobalKey _sidoKey;
  late GlobalKey _sigunguKey;
  late GlobalKey _interestFieldKey;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    FamilyState familyState = Provider.of<FamilyState>(context, listen: false);

    loader = CustomLoader();

    _name = TextEditingController();
    _bio = TextEditingController();
    _sido = TextEditingController();
    _sigungu = TextEditingController();
    _interestField = TextEditingController();

    // 유저의 가족이 셋팅되어 있는경우 가족의 정보를 불러온다.

    if (familyState.familyModel != null) {
      FamilyModel _familyModel = familyState.familyModel!;

      _name.text = _familyModel.name;
      _sido.text = _familyModel.sido ?? '';
      _sigungu.text = _familyModel.sigungu ?? '';
      _interestField.text = _familyModel.interestField ?? '';
      _bio.text = _familyModel.bio;

      if (_familyModel.anniversarys != null) {
        _familyModel.anniversarys!.forEach((value) {
          _anniversarys.add(value);
        });
      }
    }

    // image Picker 초기화
    _imagePicker = CustomImagePicker(
        targetContext: context,
        onImageSelected: (file) {
          setState(() {
            if (_imageType == ImageType.BANNER) {
              _familyBanner = file;
            } else {
              _familyImage = file;
            }
          });
        });

    // 시도선택 Picker 초기화
    _sidoPicker = CustomPicker(
        itemList: Constants.sido,
        onItemSelected: (item) {
          _sido.text = item;
          // 시도에 따라 시군구 아이템 리스트 변경
          _sigunguPicker.itemLst = Constants.sidogungu[item]!;

          //바로 시군구선택
          Future.delayed(Duration.zero, () => {_sigunguPicker.openPicker()});
        },
        targetContext: context);

    // 시군구선택 Picker 초기화
    _sigunguPicker = CustomPicker(
      itemList: ['시도를 먼저 선택해주세요'],
      onItemSelected: (item) {
        if (item != '시도를 먼저 선택해주세요') _sigungu.text = item;
      },
      targetContext: context,
    );

    // 관심분야 Picker 초기화
    _interestFieldPicker = CustomPicker(
        itemList: Constants.interestField,
        onItemSelected: (item) {
          _interestField.text = item;
        },
        targetContext: context);

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _sido.dispose();
    _sigungu.dispose();
    _interestField.dispose();

    super.dispose();
  }

  Widget _body() {
    var familyState = Provider.of<FamilyState>(context, listen: false);

    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverAppBar(
          actions: <Widget>[
            InkWell(
              onTap: _submitButton,
              child: Center(
                child: Text(
                  '완료',
                  style: true
                      ? TextStyles.appbarEnableButtonText
                      : TextStyles.appbarDisalbeButtonText,
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
          expandedHeight: 250,
          collapsedHeight: 90,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground
            ],
            background: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                SizedBox.expand(
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    height: 30,
                    color: Colors.white,
                  ),
                ),
                // Container(height: 50, color: Colors.black),
                _bannerImage(familyState),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Transform.translate(
                offset: const Offset(0, 40), child: _userImage(familyState)),
          ),
        ),
        SliverFillRemaining(
            /* hasScrollBody 를 false로 설정하면 widget 컨텐츠 만큼 높이가 맞춰지고, 컨텐츠에 따라 스크롤영역이 길어진다.(overflow 에러해결)
             hasScorllBody 를 true로 설정하면 SliverAppbar가 완전히 올라갔을때의 화면높이만큼 기본적으로 스크롤이 생긴다.(true일때  widget이 너무많아 화면길이를 넘기면 overflow 에러발생)*/
            hasScrollBody: false,
            child: Container(
              color: AppColor.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: customText('필수정보',
                                style: TextStyles.inputGuideText),
                          ),
                          Divider(
                            thickness: 1,
                            color: HongsiColor.persimmon,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: customText('가족명',
                                        style: TextStyles.inputGuideText2),
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: _entry(
                                    title: '가족 닉네임을 입력하세요',
                                    controller: _name,
                                    textInputAction: TextInputAction.done,
                                  ),
                                  flex: 5),
                            ],
                          ),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: customText('선택정보',
                                style: TextStyles.inputGuideText),
                          ),
                          Divider(
                            thickness: 1,
                            color: HongsiColor.persimmon,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: customText('관심',
                                        style: TextStyles.inputGuideText2),
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        _interestFieldPicker.openPicker();
                                      },
                                      child: IgnorePointer(
                                          child: _entry(
                                        title: '우리가족 관심분야',
                                        controller: _interestField,
                                        textInputAction: TextInputAction.done,
                                      ))),
                                  flex: 5),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: customText('지역',
                                        style: TextStyles.inputGuideText2),
                                  ),
                                  flex: 2),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _sidoPicker.openPicker();
                                    },
                                    child: IgnorePointer(
                                        child: _entry(
                                      title: '시도',
                                      controller: _sido,
                                      padding:
                                          EdgeInsets.only(left: 20, right: 10),
                                      textInputAction: TextInputAction.done,
                                    ))),
                                flex: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _sigunguPicker.openPicker();
                                    },
                                    child: IgnorePointer(
                                      child: _entry(
                                        title: '시군구',
                                        controller: _sigungu,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 20),
                                        textInputAction: TextInputAction.done,
                                      ),
                                    )),
                                flex: 5,
                              ),
                            ],
                          ),
                          Theme(
                            // 펼쳤을때 border를 지우기 위함
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              leading: IconButton(
                                icon: Icon(Icons.add_box_rounded),
                                color: HongsiColor.persimmon,
                                onPressed: () {
                                  Provider.of<RouteManager>(context,
                                          listen: false)
                                      .push(RoutePath.otherPage(
                                          RouteName.EDIT_ANNIVERSARY,
                                          args: (anniversary) {
                                    setState(() {
                                      _anniversarys.add(anniversary);
                                    });
                                  }));
                                },
                              ),
                              title: Row(
                                children: [
                                  customText('기념일'),
                                  if (_anniversarys.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: CircleAvatar(
                                        backgroundColor: HongsiColor.persimmon,
                                        radius: 8,
                                        child: customText(
                                          _anniversarys.length.toString(),
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 7.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  _anniversaryTileExpanded
                                      ? Icons.arrow_drop_down_circle
                                      : Icons.arrow_drop_down,
                                ),
                              ),
                              children: _anniversarys
                                  .map<ListTile>(
                                    (anniversary) => ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: EdgeInsets.only(
                                          left: 30.0, right: 10.0),
                                      trailing: IconButton(
                                        icon: Icon(Icons.remove_circle,
                                            color: HongsiColor.ceriseRed),
                                        onPressed: () {
                                          setState(() {
                                            _anniversarys.remove(anniversary);
                                          });
                                        },
                                      ),
                                      title: Text(anniversary['name']!),
                                      subtitle: Text(
                                          DateFormat('(yyyy년 MM월 dd일)').format(
                                              anniversary['date'].toDate())),
                                    ),
                                  )
                                  .toList(),
                              onExpansionChanged: (bool expanded) {
                                setState(
                                    () => _anniversaryTileExpanded = expanded);
                              },
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: customText('가족소개',
                                style: TextStyles.inputGuideText),
                          ),
                          Divider(
                            thickness: 1,
                            color: HongsiColor.persimmon,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, bottom: 23),
                                    child: customText('설명',
                                        style: TextStyles.inputGuideText2),
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: _entry(
                                    title: '우리가족을 소개해주세요',
                                    controller: _bio,
                                    keyboardType: TextInputType.multiline,
                                    maxLine: null,
                                    maxLength: 300,
                                    textInputAction: TextInputAction.newline,
                                  ),
                                  flex: 5),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Widget _userImage(FamilyState familyState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: (_familyImage != null
            ? FileImage(_familyImage!)
            : customAdvanceNetworkImage(familyState.familyModel == null
                ? null
                : familyState.familyModel!.familyImage)) as ImageProvider,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                _imageType = ImageType.PROFILE;
                _imagePicker.openImagePicker();
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage(FamilyState familyState) {
    return Container(
      height: 300,
      child: Container(
        margin: EdgeInsets.only(top: 90),
        decoration: const BoxDecoration(
          color: AppColor.lightGrey,
        ),
        child: Stack(
          children: [
            Center(
                child: customText('탭하여 우리가족 배경화면을 추가하세요',
                    style: TextStyles.textStyle14)),
            if (familyState.familyModel != null)
              CacheImage(
                path: familyState.familyModel!.bannerImage ??
                    'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                fit: BoxFit.fill,
              ),
            if (_familyBanner != null)
              Image.file(_familyBanner!,
                  fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: IconButton(
                  onPressed: () {
                    _imageType = ImageType.BANNER;
                    _imagePicker.openImagePicker();
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entry({
    String? title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxLine = 1,
    int? maxLength,
    bool isenable = true,
    TextInputAction textInputAction = TextInputAction.done,
    Function()? onEditingComplete,
    FocusNode? focusNode,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 20),
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: keyboardType,
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            maxLength: maxLength,
            textInputAction: textInputAction,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            decoration: InputDecoration(
                hintText: title,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.lightGrey, width: 0.5))),
          )
        ],
      ),
    );
  }

  void _submitButton() async {
    loader.showLoader(context);

    var familyState = Provider.of<FamilyState>(context, listen: false);

    FamilyModel familyModel = FamilyModel(
      // key 는 아래 family_state의 createFamily 메소드내부에서 셋팅
      id: familyState.familyModel?.id,
      name: _name.text,
      // [todo] cloud function 으로 구현
      sido: _sido.text,
      sigungu: _sigungu.text,
      bio: _bio.text,
      interestField: _interestField.text,
      anniversarys: _anniversarys,
      bannerImage: familyState.familyModel?.bannerImage,
      familyImage: familyState.familyModel?.bannerImage,
      createdAt: familyState.familyModel?.createdAt,
      updatedAt: DateTime.now().toUtc().toString(),
    );

    await familyState.createOrUpdateFamily(
        familyModel: familyModel,
        buildContext: context,
        familyImage: _familyImage,
        bannerImage: _familyBanner);

    loader.hideLoader();

    Navigator.of(context).pop(widget.onCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            // 빈 화면을 클릭했을때 현재 포커스 unFocus 처리
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: _body()),
    );
  }
}
