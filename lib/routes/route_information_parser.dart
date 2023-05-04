import 'package:flutter/material.dart';
import 'package:hongsi_project/routes/route_path.dart';

import 'package:hongsi_project/helper/enum.dart';

// Routes Information Parser 와  restoreRouteInformation은 웹에서 URL 동기화를 위한 목적
/// parseRouteInformation will convert the given route information into parsed data to pass to RouterDelegate.
class RoutesInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    // converting the url into custom class T (RoutePath)

    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return RoutePath.splash();
    }

    /// 추후 다시작성
    return RoutePath.otherPage(RouteName.SIGNUP);

    /*
    if (uri.pathSegments.length == 1) {
      final pathName = uri.pathSegments.elementAt(0).toString();

      return RoutePath.otherPage(pathName);
    } else if (uri.pathSegments.length == 2) {
      final complexPath = uri.pathSegments.elementAt(0).toString() +
          "/" +
          uri.pathSegments.elementAt(1).toString();
      return RoutePath.otherPage(complexPath.toString());
    } else {
      return RoutePath.otherPage(uri.pathSegments.toString());
    }

    */
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: '/error');
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isOtherPage) {
      return RouteInformation(location: '/${configuration.pathName}');
    }

    return const RouteInformation(location: null);
  }
}
