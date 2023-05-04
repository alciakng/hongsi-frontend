import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:hongsi_project/helper/constant.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/model/user_model.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/theme/theme.dart';

/// [Common Custom widget]
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/widgets/common/custom_form_filed.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';

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

// defualt 페이지 상수
const int MAX_PAGE = 3;
const double INITIAL_PAGE = 0.0;

/* ------------------------------------------------------------------------------------------------
이   름 : signup_page.dart
기   능 : 이메일 회원가입 진행
참고사항 : 1) 
수정이력 : 1) 2022/06/11  [김종환]  최초 작성
         2) 2022/07/24  [김종환]  Social 로그인을 하는 경우 curPage, maxPage, channel 을 arguments 로 받아 SignUpPage을 구성하도록 처리
--------------------------------------------------------------------------------------------------- */
class SignUpPage extends StatefulWidget {
  // 로그인 콜백함수
  final VoidCallback? loginCallback;
  String? channel;

  /// 최대페이지 수, 현재페이지  - 진행바(progress indicator)를 컨트롤하기 위한 변수
  late int maxPage = MAX_PAGE;
  double curPage = INITIAL_PAGE;
  late double progressValue = (curPage + 1) / maxPage;

  SignUpPage({Key? key, this.loginCallback, this.channel}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;
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
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nicknameController.dispose();
    _rolenameController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  Widget _emailInput() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomFormField(
            textEditingController: _emailController,
            onChanged: (val) {
              setState(() {
                _validDelegate.emailValidator(val);
              });
            },
            hintText: 'HongsiClub@hongsiclub.com',
            guideText: '이메일을 입력해주세요.',
            isEmail: true,
            isPassword: false,
            errorText: _validDelegate.emailErrorText,
          ),
          // _entryFeild('Mobile no',controller: _mobileController),
          SizedBox(
            height: 30,
          ),
          _submitButton(_validDelegate.emailValid ?? false),
        ],
      ),
    );
  }

  Widget _passwordInput() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomFormField(
            textEditingController: _passwordController,
            onChanged: (val) {
              setState(() {
                _validDelegate.passwordValidator(val);

                _validDelegate.confirmPasswordValidator(
                    val, _confirmController.text);
              });
            },
            hintText: '영어 소문자, 숫자 조합 8~15자',
            guideText: '비밀번호를 입력해주세요.',
            isEmail: false,
            isPassword: true,
            errorText: _validDelegate.passwordErrorText,
          ),
          CustomFormField(
            textEditingController: _confirmController,
            onChanged: (val) {
              setState(() {
                _validDelegate.confirmPasswordValidator(
                    _passwordController.text, val);
              });
            },
            hintText: '다시 한번 입력해주세요.',
            isEmail: false,
            isPassword: true,
            errorText: _validDelegate.confirmPasswordErrorText,
          ),
          _submitButton(_validDelegate.passwordCheckValid ?? false),
        ],
      ),
    );
  }

  Widget _etcInput() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
            hintText: 'ex) 김포 멋쟁이 홍시, 잘생긴 연시',
            guideText: '닉네임을 입력해주세요.',
            isEmail: false,
            isPassword: false,
            errorText: _validDelegate.nicknameErrorText,
          ),
          SizedBox(
            height: 50,
          ),
          CustomFormField(
            textEditingController: _rolenameController,
            onChanged: (val) {
              setState(() {
                _validDelegate.rolenameValidator(val);
              });
            },
            hintText: 'ex) 수퍼맨 아빠, 든든한 아들, 행복한 엄마',
            guideText: '역할을 입력해주세요.',
            isEmail: false,
            isPassword: false,
            errorText: _validDelegate.rolenameErrorText,
          ),
          _submitButton(_validDelegate.nameCheckValid ?? false),
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

  /*----------------------------------------------------------------------------
  - 함수 : _submitForm
  - 기능 : 회원가입 정보들을 바탕으로 [auth_state.dart] 의 signUp 메서드를 호출한다. 
  - @param {} 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  ------------------------------------------------------------------------------*/
  void _submitForm() {
    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);

    UserModel user = UserModel(
      // key, uid 는 아래 auth_state의 signUp 메소드내부에서 셋팅
      email: _emailController.text.toLowerCase(),
      username: _nicknameController.text,
      role: _rolenameController.text,
      channel: Channel.EMAIL.name,
      grade: Grade.E.name,
      level: Level.FIVE.name,
      createdAt: DateTime.now().microsecondsSinceEpoch,
    );

    /*
    /// auth_state의 signUp 메서드를 호출한다.
    state
        .signUp(
      user,
      password: _passwordController.text,
      scaffoldMessengerKey: _scaffoldMessengerKey,
    )
        .then((status) {
      _afterLogin(status);
    }).whenComplete(
      () {},
    );
    */
  }

  /*-----------------------------------------------------------------------------------------------------------------------
  - 함수 : _submitSocialForm
  - 기능 : 소셜로그인의 경우 auth_state의 소셜로그인 함수를 선 호출후 signup_page의 이름,역할을 입력받고 다시 auth_state의 createUser를 셋팅한다.
  -       (호출순서 : 1️⃣ auth_state - handleKakaoSignIn 2️⃣ signup_page - _submitSocialForm 3️⃣ auth_state - createUser )
  - @param {} 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  -------------------------------------------------------------------------------------------------------------------------*/
  void _submitSocialForm() {
    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);

    // 유저모델 생성
    UserModel model = UserModel(
      uid: state.userModel!.uid, // uid는 화면으로 넘어오기전 이미 auth_state 에서 셋팅
      email: state.userModel!.email,
      username: _nicknameController.text,
      role: _rolenameController.text,
      channel: widget.channel,
      grade: Grade.E.name, // default 초기등급
      level: Level.FIVE.name, // default Level
      leader: false, // default false (가족리더여부)
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    // 유저생성
    // [todo] 에러처리 분기
    state.createUser(model, newUser: true);

    _afterLogin(state.authStatus);
  }

  /*-----------------------------------------------------------------------------------------------------------------------
  - 함수 : _afterLogin
  - 기능 : 로그인 완료 후 처리
  - @param {} 
  - @return {} 
  - 이력 : 2022.06.15 / 김종환 / 최초생성 
  -------------------------------------------------------------------------------------------------------------------------*/
  void _afterLogin(AuthStatus? status) {
    loader.hideLoader();
    if (status == AuthStatus.LOGGED_IN) {
      Navigator.pop(context);
      if (widget.loginCallback != null) widget.loginCallback!();
    } else {
      // 에러메시지는 handleKakaoSignIn에서 처리
      Navigator.pop(context);

      //[todo] 로그인 실패 snack bar 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    var authState = context.read<AuthState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: customText(
            '회원가입',
            context: context,
          ),
          centerTitle: true,
          leading: GestureDetector(
            // [뒤로가기버튼 아이콘]
            child: Icon(
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
                  authState.logoutCallback();
                }
                // 뒤로가기
                Navigator.pop(context);
              }
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn);
            },
          ),
          // [로그인 진행 바]
          bottom: CustomLinearProgressIndicator(
            // 진행상태 표현 - 첫 페이지에서 bar가 일부 나와있는 모습을 표현하기 위하여 +1 처리
            value: widget.progressValue,
          ),
        ),
        // [PageView 로그인 폼]
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            // 이메일 방식 회원가입인 경우에만 email, password 입력란을 활성화
            _emailInput(),
            _passwordInput(),
            _etcInput()
          ],
        ));
  }
}
