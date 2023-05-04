import 'route_path.dart';

// delegate interface that can be overriden. I define it in this to allow for anonymous inline handlers
// as opposed to a more traditional class hierachy.

//나중에 없어져야 할 클래스, delegate 안에 로직으로 구현.
class RouteManagerDelegate {
  factory RouteManagerDelegate() => _instance;
  RouteManagerDelegate._();
  static final RouteManagerDelegate _instance = RouteManagerDelegate._();

  late Function(RoutePath) _onPush;
  late Function _onPop;
  late Function _onReset;

  // setters to allow override of callbacks
  set onPush(Function(RoutePath) callback) => _onPush = callback;
  set onPop(Function callback) => _onPop = callback;
  set onReset(Function callback) => _onReset = callback;

  void push(RoutePath path) {
    if (_onPush != null) _onPush(path);
  }

  void pop() {
    if (_onPop != null) _onPop();
  }

  void reset() {
    if (_onReset != null) _onReset();
  }
}

// Manager that is available to screens throughout the application if exposed
// via a Provider. This is an interface to perform operations that can be handled
// by a delegate defined inside a particular RouterDelegate.
//
// ex/ A Router Delegate may be implemented as a Stack, in which case it would want
// to define implementations for push/pop/reset. Alternatively, a Router Delegate may be
// used as a way to display Tabs, in which case additional interfaces could be defined to
// handle that (select for example).
class RouteManager {
  void push(RoutePath path) {
    RouteManagerDelegate().push(path);
  }

  void pop() {
    RouteManagerDelegate().pop();
  }

  void reset() {
    RouteManagerDelegate().reset();
  }
}
