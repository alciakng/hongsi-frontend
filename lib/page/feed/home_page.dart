import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/state/family_state.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/button/custom_text_button.dart';
import 'package:hongsi_project/widgets/common/custom_dialog.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';

// go_router 로 대체
//import 'package:hongsi_project/routes/route_manager.dart' show RouteManager;
//import 'package:hongsi_project/routes/route_path.dart';
//import 'package:hongsi_project/helper/enum.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // postFrameCallback 등록
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAlert(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var authState = context.read<AuthState>();
    var familyState = context.read<FamilyState>();

    return Center(
        child: CustomTextButton(
      label: '로그아웃',
      onPressed: () async {
        //로그아웃
        await authState.logoutCallback().then((_) {
          //family 변수초기화
          familyState.clearVariable();
          // welcome 페이지 이동
          context.go('/welcome');
        });
      },
    ));
  }

  void _showAlert(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                      style: TextStyles.dark16Normal,
                      "소속된 가족이 없습니다.\n가족을 초대하거나 찾아보세요🙂"),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              callback: () {
                context.go('/searchFamily');
              });
        });
  }
}
