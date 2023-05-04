import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hongsi_project/state/auth_state.dart';
import 'package:hongsi_project/theme/theme.dart';

/// SplashPage
/// 최초 화면진입시 구동페이지
/// go_router 에서 SplashPage 진입 시 로그인여부에 따라 WelcomePage() 또는 HomePage() 로 redirection
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  /// TODO - app 버전 check (go_router 내부에서 버전체크 후 redirect 하는 방식으로 해도 괜찮을 것 같음)
  /// Check if current app is updated app or not
  /// If app is not updated then redirect user to update app screen
  ///

  /*
  void timer() async {
    //final isAppUpdated = await _checkAppVersion();
    //if (isAppUpdated) {
    //cprint("App is updated");

    });
    //}
    
  }*/

  /// Return installed app version
  /// For testing purpose in debug mode update screen will not be open up
  /// If an old version of app is installed on user's device then
  /// User will not be able to see home screen
  /// User will redirected to update app screen.
  /// Once user update app with latest verson and back to app then user automatically redirected to welcome / Home page
  /*
  Future<bool> _checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentAppVersion = packageInfo.version;
    final buildNo = packageInfo.buildNumber;
    final config = await _getAppVersionFromFirebaseConfig();

    if (config != null &&
        config['name'] == currentAppVersion &&
        config['versions'].contains(int.tryParse(buildNo))) {
      return true;
    } else {
      if (kDebugMode) {
        cprint("Latest version of app is not installed on your system");
        cprint(
            "This is for testing purpose only. In debug mode update screen will not be open up");
        cprint(
            "If you are planning to publish app on store then please update app version in firebase config");
        return true;
      }
      Navigator.pushReplacement(context, UpdateApp.getRoute());
      return false;
    }
  }
  */

  /// Returns app version from firebase config
  /// Fecth Latest app version from firebase Remote config
  /// To check current installed app version check [version] in pubspec.yaml
  /// you have to add latest app version in firebase remote config
  /// To fetch this key go to project setting in firebase
  /// Open `Remote Config` section in fireabse
  /// Add [supportedBuild]  as paramerter key and below json in Default value
  ///  ```
  ///  {
  ///    "supportedBuild":
  ///    {
  ///       "name": "<Current Build Version>","
  ///       "versions": [ <Current Build Version> ]
  ///     }
  ///  } ```
  /// After adding app version key click on Publish Change button
  /// For package detail check:-  https://pub.dev/packages/firebase_remote_config#-readme-tab-
  /*
  Future<Map?> _getAppVersionFromFirebaseConfig() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    // await remoteConfig.activateFetched();
    var data = remoteConfig.getString('supportedBuild');
    if (data.isNotEmpty) {
      return jsonDecode(data) as Map;
    } else {
      cprint(
          "Please add your app's current version into Remote config in firebase",
          errorIn: "_getAppVersionFromFirebaseConfig");
      return null;
    }
  }
  */

  Widget _body() {
    var height = 150.0;
    return SizedBox(
      height: context.height,
      width: context.width,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              /// TODO  아이콘 제작하여 변경필요
              Platform.isIOS
                  ? const CupertinoActivityIndicator(
                      radius: 35,
                    )
                  : const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
              Image.asset(
                'assets/images/ripple.png',
                height: 30,
                width: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }
}
