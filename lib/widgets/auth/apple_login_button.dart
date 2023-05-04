import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';
import 'package:hongsi_project/widgets/common/custom_title_text.dart';

import 'package:hongsi_project/routes/route_manager.dart' show RouteManager;
import 'package:hongsi_project/routes/route_path.dart';
import 'package:hongsi_project/helper/enum.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({
    Key? key,
    required this.loader,
    this.loginCallback,
  }) : super(key: key);

  final CustomLoader loader;
  final Function? loginCallback;

  void _appleLogin(context) {
    // [todo] - provider 를 쓸 필요없이 싱글톤 객체로 관리하면됨
    Provider.of<RouteManager>(context, listen: false).push(RoutePath.otherPage(
        RouteName.SIGNUP,
        args: {'channel': Channel.GOOGLE}));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _appleLogin(context);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all(const Color(0xff000000)),
        shape: MaterialStateProperty.all(
          CircleBorder(),
        ),
      ),
      child: Image.asset(
        'assets/images/apple_logo.png',
        height: 30,
        width: 30,
      ),
    );
  }
}
