import 'package:flutter/material.dart';
import 'package:hongsi_project/page/common/splash.dart';
import 'package:hongsi_project/page/auth/welcome_page.dart';
import 'package:hongsi_project/routes/route_mapper.dart';

import 'package:provider/provider.dart';

//utility.dart => firestore 사용하기 위함
import 'package:hongsi_project/helper/utility.dart';
//firebase_auth.dart => 현재 user를 참조하기 위함
import 'package:firebase_auth/firebase_auth.dart';
//route_path.dart =>
import 'package:hongsi_project/routes/route_path.dart';
//custom_navigation_key.dart => navigation key를 정의한다.
import 'package:hongsi_project/helper/custom_navigation_key.dart';

import 'package:hongsi_project/routes/route_stack.dart';

import 'package:hongsi_project/routes/route_manager.dart';

import 'package:hongsi_project/helper/enum.dart';

/// AppRouterDelegate includes the parsed result from RoutesInformationParser
class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  User? curUser;
  RouteName? pathName;
  bool isError = false;

  // This router uses a Stack to push/pop/reset. All paths are stored in this stack
  // and it notifies out when any changes are made.
  final RouteStack stack = RouteStack(root: RoutePath.splash());

  AppRouterDelegate({Key? key}) : super() {
    // inline handlers for navigation to allow to receive intents from users
    // who interact with the Navigation Manager of this class
    RouteManagerDelegate().onPush = (RoutePath path) {
      pathName = path.pathName;
      stack.push(path);
    };

    RouteManagerDelegate().onPop = () {
      stack.pop();
    };

    RouteManagerDelegate().onReset = () {
      stack.reset();
    };

    // connect the notifier of the PathStack to the router notifier to trigger
    // a re-draw of this router with all the paths
    stack.addListener(notifyListeners);
  }

  /// currentConfiguration detects a route information may have changed as a result of rebuild.
  @override
  RoutePath get currentConfiguration {
    if (isError) {
      return RoutePath.unknown();
    }

    if (pathName == null) {
      return RoutePath.splash(); //main
    }

    return RoutePath.otherPage(pathName);
  }

  @override
  Future<void> setInitialRoutePath(RoutePath configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setRestoredRoutePath(RoutePath configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      CustomNavigationKeys.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      //transitionDelegate: transitionDelegate,
      key: navigatorKey,
      pages: stack.items.asMap().entries.map((e) {
        int index = e.key;
        RoutePath configuration = e.value;
        // iterate through each of the pages in our stack and construct them
        // providing the same key should prevent a new item from being created
        // so let's use the index which will be unique
        ValueKey key = ValueKey(index);

        return MaterialPage(
            key: key,
            child: RouteMapper()
                .routeMapper(configuration.pathName!, configuration.arguments));
      }).toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // if we are on the route of the application, the lander, we probably want to just exit
        // returning false means we want the OS to handle the back press
        if (stack.items.length == 1) {
          return false;
        }

        // remove from the stack and consume the back event so the
        // OS doesn't exit
        stack.pop();
        return true;
      },
    );
  }

  /// setNewRoutePath is called when a new route has been pushed to the application.
  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    /*
    curUser = firebaseAuth.currentUser;

    if (configuration.isOtherPage) {
      pathName = configuration.pathName;
      isError = false;
    } else {
      pathName = 'splash';
      isError = false;
    }

    notifyListeners();
    */
    if (configuration.pathName != null) {
      stack.push(configuration);
    }
  }

  /*
  void setPathName(String path) async {
    pathName = path;
    await setNewRoutePath(RoutePath.otherPage(pathName));
    notifyListeners();
  }
  */
}
