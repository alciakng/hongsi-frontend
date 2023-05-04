import 'package:flutter/material.dart';
import 'package:hongsi_project/page/auth/signup_page.dart';

import 'package:hongsi_project/page/common/splash.dart';
import 'package:hongsi_project/page/auth/signup_page.dart';

import 'package:hongsi_project/helper/enum.dart';
import 'package:hongsi_project/page/family/edit_anniversary_page.dart';
import 'package:hongsi_project/page/family/edit_family_page.dart';
import 'package:hongsi_project/page/family/family_notification.dart';
import 'package:hongsi_project/page/family/search_family_page.dart';

// 나중에 없어져야할 클래스. deletgate 안에 로직으로 구현
/// Class to handle route path related informations
class RouteMapper {
  static final RouteMapper _instance = RouteMapper._();
  factory RouteMapper() => _instance;
  RouteMapper._();

  /// Returns [WidgetToRender, PathName]
  /// [WidgetToRender] - Renders specified widget
  /// [PathName] - Re-directs to [PathName] if invalid path is entered
  Widget routeMapper(RouteName pathName, dynamic arguments) {
    switch (pathName) {
      case RouteName.SPLASH:
        return const SplashPage();
      //case RouteName.SIGNUP:
      //return SignUpPage(arguments: arguments);
      case RouteName.SEARCH_FAMILY:
        return SearchFamily();
      case RouteName.EDIT_FAMILY:
        return EditFamilyPage(onCompleted: arguments);
      case RouteName.EDIT_ANNIVERSARY:
        return EditAnniversaryPage(onCompleted: arguments);
      case RouteName.FAMILY_NOTIFICATION:
        return FamilyNotification();
      default:
        return const SplashPage();
    }
  }
}
