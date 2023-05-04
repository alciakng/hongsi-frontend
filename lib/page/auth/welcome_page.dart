import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/widgets/auth/email_login_button.dart';
import 'package:hongsi_project/widgets/common/custom_widgets.dart';
import 'package:provider/provider.dart';

import 'package:hongsi_project/state/auth_state.dart';

// [widget]
import 'package:hongsi_project/widgets/common/custom_title_text.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/widgets/auth/kakao_login_button.dart';
import 'package:hongsi_project/widgets/auth/google_login_button.dart';
import 'package:hongsi_project/widgets/auth/apple_login_button.dart';
import 'package:hongsi_project/widgets/auth/email_login_button.dart';
// [loader]
import 'package:hongsi_project/widgets/common/custom_loader.dart';

import 'package:hongsi_project/routes/route_delegate.dart';

import 'package:hongsi_project/page/feed/home_page.dart';

import 'package:hongsi_project/theme/theme.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late CustomLoader loader;

  @override
  void initState() {
    loader = CustomLoader();
    super.initState();
  }

  Widget kakaoSection() {
    return Container(
      alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: KakaoLoginButton(loader: loader),
        )
      ]),
    );
  }

  Widget dividerSection() {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: const Divider(
              thickness: 0.5,
              color: Colors.grey,
              height: 50,
            )),
      ),
      TitleText(
        "OR",
        color: Colors.grey,
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: const Divider(
              thickness: 0.5,
              color: Colors.grey,
              height: 50,
            )),
      ),
    ]);
  }

  Widget etcSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GoogleLoginButton(loader: loader),
        AppleLoginButton(loader: loader),
        EmailLoginButton(loader: loader),
      ],
    );
  }

  Widget _Welcome() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Center(
                child:
                    customText('가족들과 더 친밀하게,', style: TextStyles.dark31Normal)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customText('홍시가족', style: TextStyles.persimmon60Bold),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 50,
                  height: 70,
                  child: Image.asset('assets/images/ripple.png'),
                  //child: const Text("홍시로고")),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            kakaoSection(),
            SizedBox(
              height: 5,
            ),
            dividerSection(),
            SizedBox(
              height: 5,
            ),
            etcSection(),
            SizedBox(
              height: 5,
            ),
          ],
        ));
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            //googleAppleSection(),
            _Welcome(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(body: _body());
  }
}
