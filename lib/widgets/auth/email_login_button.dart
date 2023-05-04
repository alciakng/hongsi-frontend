import 'package:flutter/material.dart';
import 'package:hongsi_project/widgets/common/custom_loader.dart';
import 'package:go_router/go_router.dart';

/*
import 'package:google_fonts/google_fonts.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:hongsi_project/helper/utility.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/widgets/common/custom_title_text.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/routes/route_delegate.dart';
import 'package:hongsi_project/routes/route_manager.dart';
import 'package:hongsi_project/routes/route_path.dart';
import 'package:hongsi_project/routes/route_mapper.dart';
*/

class EmailLoginButton extends StatelessWidget {
  const EmailLoginButton({
    Key? key,
    required this.loader,
    this.loginCallback,
  }) : super(key: key);

  final CustomLoader loader;
  final Function? loginCallback;

  void _emailLogin(BuildContext context) {
    // [todo] - provider 를 쓸 필요없이 싱글톤 객체로 관리하면됨
    /*    
    Provider.of<RouteManager>(context, listen: false)
        .push(RoutePath.otherPage(RouteName.SIGNUP));
    */
    context.push('/signUp');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _emailLogin(context);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all(const Color(0xffFF5E00)),
        shape: MaterialStateProperty.all(
          const CircleBorder(),
        ),
      ),
      child: Image.asset(
        'assets/images/mail_logo.png',
        height: 30,
        width: 30,
      ),
    );
  }
}
