import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hongsi_project/theme/theme.dart';
import 'package:hongsi_project/widgets/button/custom_text_button.dart';
import 'package:hongsi_project/widgets/common/custom_dialog.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:hongsi_project/state/auth_state.dart';
import '../../state/family_state.dart';

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
    var authState = Provider.of<AuthState>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    var familyState = Provider.of<FamilyState>(context, listen: false);

    // 소속된 가족이 없을 경우 안내
    if (familyState.familyModel == null) {
      Future.delayed(Duration.zero, () => _showAlert(context));
    }

    return Center(
        child: CustomTextButton(
      label: '로그아웃',
      onPressed: () async {
        //로그아웃
        await authState.logoutCallback();
        //family 변수초기화
        familyState.clearVariable();
        // welcome 페이지 이동
        context.go('/welcome');
      },
    ));
  }

  void _showAlert(BuildContext context) {
    showDialog(
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
