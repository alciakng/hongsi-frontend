import 'package:hongsi_project/helper/enum.dart';

class RoutePath {
  final RouteName? pathName;
  final bool isUnknown;
  dynamic arguments;

  // named 생성자 - splash
  RoutePath.splash()
      : pathName = RouteName.SPLASH,
        isUnknown = false;
  // named 생성자 - home
  RoutePath.home(this.pathName) : isUnknown = false;
  // named 생성자 - arguments
  RoutePath.otherPage(this.pathName, {dynamic args}) : isUnknown = false {
    arguments = args;
  }
  // named 생성자 - unknown
  RoutePath.unknown()
      : pathName = null,
        isUnknown = true;

  bool get isHomePage => pathName == null && isUnknown == false;
  bool get isUnkownPage => pathName == null && isUnknown == true;
  bool get isOtherPage => pathName != null;
}
