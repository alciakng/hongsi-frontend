import 'package:flutter/material.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:go_router/go_router.dart';

class GoogleLoginButton extends StatelessWidget {
  GoogleLoginButton({
    Key? key,
    required this.loader,
    this.loginCallback,
  }) : super(key: key);

  final CustomLoader loader;
  final Function? loginCallback;

  void _googleLogin(BuildContext context) {
    // onClick 이벤트는 위젯트리 밖에서 Provider를 호출하기때문에 listen:false 를 꼭 해야한다.
    final authState = Provider.of<AuthState>(context, listen: false);

    authState.handleGoogleSignIn().then((status) {
      switch (status) {
        case AuthStatus.LOGGED_IN:
          if (authState.userModel != null) {
            /// userModel중 role이 null 인경우 (추가정보입력여부)
            if (authState.userModel!.role == null) {
              context.push('/aditInfo/${Channel.GOOGLE.name}');
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
    /*
    if (authStatus == AuthStatus.LOGGED_IN) {
      /// userModel이 null인 경우
      if (authState.userModel == null) {
        /// userModel중 role이 null 인경우 (추가정보입력여부)
        if (authState.userModel!.role == null) {
          context.go('/signUp/' + Channel.GOOGLE.name);
        } else {
          context.go('/home');
        }
      } else {}
    */
    /* [todo] - provider 를 쓸 필요없이 싱글톤 객체로 관리하면됨
        Provider.of<RouteManager>(context, listen: false).push(
            RoutePath.otherPage(RouteName.SIGNUP,
                args: {'channel': Channel.GOOGLE}));*/
    /* userModel - 소속된 가족이 없는 경우 가족찾기 페이지로 이동
        if (authState.userModel!.famList == null) {
          // [todo] - provider 를 쓸 필요없이 싱글톤 객체로 관리하면됨
          Provider.of<RouteManager>(context, listen: false)
              .push(RoutePath.otherPage(RouteName.SEARCH_FAMILY));
        }*/
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _googleLogin(context);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(EdgeInsets.all(12.0)),
        backgroundColor: MaterialStateProperty.all(const Color(0xffffffff)),
        shape: MaterialStateProperty.all(const CircleBorder(
            side: BorderSide(color: AppColor.darkGrey, width: 0.5))),
      ),
      child: Image.asset(
        'assets/images/google_logo.png',
        height: 30,
        width: 30,
      ),
    );
  }
}
