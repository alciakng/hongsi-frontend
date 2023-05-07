import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:hongsi_project/helper/constant.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/user_model.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/common/custom_dialog.dart';

/// [Common Custom widget]
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/widgets/common/custom_form_filed.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';
import 'package:hongsi_project/widgets/button/custom_text_button.dart';

/// [kakao sdk] - enum 에서 Channel을 사용하기 때문에 hide Channel 처리 ('package:kakao_flutter_sdk_talk/src/model/channel.dart')
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide Channel;

/// [provider]
import 'package:provider/provider.dart';

/// [validDelegate]
import 'package:hongsi_project/page/auth/common/validator.dart';

/// [progress indicator] - 회원가입 페이지 상단 진행 바
import 'package:hongsi_project/widgets/common/custom_linear_progress_indicator.dart';

/// [enum] - channel사용
import 'package:hongsi_project/helper/enum.dart';

// [router] goRouter
import 'package:go_router/go_router.dart';

// defualt 페이지 상수
const int SOCIAL_MAX_PAGE = 1;
const double INITIAL_PAGE = 0.0;

/* ------------------------------------------------------------------------------------------------
이   름 : aditInfoPage.dart
기   능 : 소셜로그인 유저의 추가정보 입력 진행
참고사항 : 1) 
수정이력 : 1) 2023/04/30 / 김종환 / 신규작성
--------------------------------------------------------------------------------------------------- */
class AditInfoPage extends StatefulWidget {
  // 로그인 콜백함수
  final VoidCallback? loginCallback;
  String? channel;

  /// 최대페이지 수, 현재페이지  - 진행바(progress indicator)를 컨트롤하기 위한 변수
  late int maxPage = SOCIAL_MAX_PAGE;
  double curPage = INITIAL_PAGE;
  late double progressValue = (curPage + 1) / maxPage;

  AditInfoPage({Key? key, this.loginCallback, this.channel}) : super(key: key) {
    /// Social 로그인을 통해 SignUpPage를 오픈하는 경우 /// 채널 할당
  }

  @override
  State<StatefulWidget> createState() => _AditInfoPageState();
}

class _AditInfoPageState extends State<AditInfoPage> {
  late TextEditingController _nicknameController;
  late TextEditingController _rolenameController;
  late CustomLoader loader;

  late PageController _pageController;

  /// 스낵바 컨트롤을 위한 스캐폴드키
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// 유효성 체크 모듈
  late ValidDelegate _validDelegate;

  @override
  void initState() {
    loader = CustomLoader();
    _nicknameController = TextEditingController();
    _rolenameController = TextEditingController();
    _pageController = PageController(initialPage: 0);

    /// 페이지가 넘겨지거나 뒤로갈때 curPage 동기화
    _pageController.addListener(() {
      setState(() {
        widget.curPage = _pageController.page!;
        widget.progressValue = (widget.curPage + 1) / widget.maxPage;
      });
    });

    _validDelegate = ValidDelegate();

    super.initState();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _rolenameController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  Widget _etcInput() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomFormField(
            textEditingController: _nicknameController,
            onChanged: (val) {
              setState(() {
                _validDelegate.nicknameValidator(val);
              });
            },
            hintText: '멋쟁이 홍시',
            guideText: '닉네임을 입력해주세요.',
            isEmail: false,
            isPassword: false,
            errorText: _validDelegate.nicknameErrorText,
          ),
          const SizedBox(
            height: 50,
          ),
          CustomFormField(
            textEditingController: _rolenameController,
            onChanged: (val) {
              setState(() {
                _validDelegate.rolenameValidator(val);
              });
            },
            hintText: '슈퍼맨 아빠',
            guideText: '역할을 입력해주세요.',
            isEmail: false,
            isPassword: false,
            errorText: _validDelegate.rolenameErrorText,
          ),
          const SizedBox(
            height: 30,
          ),
          _submitButton(_validDelegate.nameCheckValid ?? false),
          const SizedBox(
            height: 10,
          ),
          CustomTextButton(
              label: "건너뛰기",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                  style: TextStyles.dark16Normal,
                                  "정말 건너뛰시겠습니까?\n일부 서비스가 제한될 수 있습니다"),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  customText(
                                      style: TextStyles.dark16Normal, "추후 "),
                                  customText(
                                      style: TextStyles.persimmon16Bold,
                                      "설정 > 내정보"),
                                  customText(
                                      style: TextStyles.dark16Normal,
                                      "에서 수정가능합니다🙂"),
                                ],
                              ),
                            ],
                          ),
                          callback: () {
                            context.go('/home');
                          });
                    });
              })
        ],
      ),
    );
  }

  /*----------------------------------------------------------------------------
  - 함수 : _submitButton
  - 기능 : 회원가입 정보들을 바탕으로 [auth_state.dart] 의 signUp 메서드를 호출한다. 
  - @param {} 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  ------------------------------------------------------------------------------*/

  Widget _submitButton(bool isValid) {
    return CustomFlatButton(
      padding: const EdgeInsets.all(13),
      label: "다음",
      color: HongsiColor.persimmon,
      isValid: isValid,
      onPressed: () {
        if (widget.curPage + 1 == widget.maxPage) {
          // 이메일방식으로 가입하는경우 _submitForm()메서드 호출, 소셜방식인경우 submitSocialForm() 메서드 호출
          _submitSocialForm();
        } else {
          // nextPage로 넘김
          _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn);
        }
      },
      borderRadius: 2,
    );
  }

  /*-----------------------------------------------------------------------------------------------------------------------
  - 함수 : _submitSocialForm
  - 기능 : 소셜로그인의 경우 auth_state의 소셜로그인 함수를 선 호출후 signup_page의 이름,역할을 입력받고 다시 auth_state의 createUser를 셋팅한다.
  -       (호출순서 : 1️⃣ auth_state - handleKakaoSignIn 2️⃣ signup_page - _submitSocialForm 3️⃣ auth_state - createUser )
  - @param {} 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  -------------------------------------------------------------------------------------------------------------------------*/
  void _submitSocialForm() async {
    loader.showLoader(context);
    var state = context.read<AuthState>();

    // usermodel 추가정보 셋팅
    if (state.userModel != null) {
      state.userModel!.username = _nicknameController.text;
      state.userModel!.role = _rolenameController.text;
      state.userModel!.channel = widget.channel;
      state.userModel!.grade = Grade.E.name;
      state.userModel!.level = Level.FIVE.name;
      state.userModel!.updatedAt = DateTime.now().millisecondsSinceEpoch;
    }
    // 유저정보 업데이트
    await state.updateUserProfile();

    _afterLogin(state.userModel);
  }

  /*-----------------------------------------------------------------------------------------------------------------------
  - 함수 : _afterLogin
  - 기능 : 로그인 완료 후 처리
  - @param {} 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
          2023.04.30 / 김종환 / 로그인 완료 후 로직 정비
  -------------------------------------------------------------------------------------------------------------------------*/
  void _afterLogin(UserModel? userModel) {
    loader.hideLoader();
    if (userModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(msg: "유저정보가 없습니다. 네트워크 상태를 확인하시고 다시 로그인 해주시기 바랍니다."));
      context.go('/welcome');
    } else {
      if (userModel.role != null) {
        context.go('/home');
        if (widget.loginCallback != null) widget.loginCallback!();
      } else {
        //로그인 실패 snack bar 출력
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar(msg: "작업을 실패하였습니다.\n네트워크 연결상태를 확인하세요."));
        // 에러메시지는 handleKakaoSignIn에서 처리
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var authState = context.read<AuthState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: customText('회원가입',
              context: context, style: TextStyles.dark18Bold),
          centerTitle: true,
          leading: GestureDetector(
            // [뒤로가기버튼 아이콘]
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            // [뒤로가기 버튼을 눌렀을때 로직]
            onTap: () {
              if (_pageController.page == 0) {
                // 컨트롤러 변수 초기화
                _validDelegate.clearVariable();
                // 로그인상태인경우 로그아웃처리
                if (authState.authStatus == AuthStatus.LOGGED_IN) {
                  authState.logoutCallback().then((_) {
                    // 뒤로가기
                    context.pop();
                  });
                }
              } else {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              }
            },
          ),
          /* [로그인 진행 바] - Social Form에서 진행하지 않음 
          bottom: CustomLinearProgressIndicator(
            // 진행상태 표현 - 첫 페이지에서 bar가 일부 나와있는 모습을 표현하기 위하여 +1 처리
            value: widget.progressValue,
          ),
          */
        ),
        // [PageView 로그인 폼]
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[_etcInput()],
        ));
  }
}
