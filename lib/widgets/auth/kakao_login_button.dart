import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';
import 'package:hongsi_project/helper/enum.dart';
// [goRouter]
import 'package:go_router/go_router.dart';

//import 'package:google_fonts/google_fonts.dart';
//import 'package:hongsi_project/helper/utility.dart';
//import 'package:hongsi_project/widgets/common/custom_title_text.dart';

// [에러처리]
//import 'package:flutter/services.dart' show PlatformException;

/// goRouter 사용으로 인한 주석처리
//import 'package:hongsi_project/routes/route_manager.dart' show RouteManager;
//import 'package:hongsi_project/routes/route_path.dart';

class KakaoLoginButton extends StatelessWidget {
  KakaoLoginButton({
    Key? key,
    required this.loader,
    this.loginCallback,
  }) : super(key: key);

  final CustomLoader loader;
  final Function? loginCallback;

  /// 스낵바 컨트롤을 위한 스캐폴드키
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _kakaoLogin(BuildContext context) async {
    // onClick 이벤트는 위젯트리 밖에서 Provider를 호출하기때문에 listen:false 를 꼭 해야한다.
    final authState = Provider.of<AuthState>(context, listen: false);

    authState
        .handleKakaoSignIn(scaffoldMessengerKey: _scaffoldMessengerKey)
        .then((status) async {
      switch (status) {
        case AuthStatus.LOGGED_IN:
          if (authState.userModel != null) {
            /// userModel중 role이 null 인경우 (추가정보입력여부)
            if (authState.userModel!.role == null) {
              context.push('/aditInfo/${Channel.KAKAO.name}');
            } else {
              context.go('/home');
            }
          }
          break;

        /// TODO 로그인 실패메시지 추가할 것
        case AuthStatus.NOT_LOGGED_IN:
        default:
          print(status);
          context.go('/welcome');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: TextButton(
          onPressed: () {
            _kakaoLogin(context);
          },
          style: ButtonStyle(
            alignment: Alignment.center,
            backgroundColor: MaterialStateProperty.all(const Color(0xffFEE500)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/kakao_logo.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                child: customText('카카오톡 간편 로그인',
                    style: TextStyles.dark22Bold, textAlign: TextAlign.start),
                flex: 5,
              ),
            ],
          ),
        ));
  }
}
