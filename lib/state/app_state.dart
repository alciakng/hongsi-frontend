import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }

  // _isBusy =>
  bool _isBusy = false;
  // isbusy => _isBusy 값을 받아온다.
  bool get isbusy => _isBusy;

  // isBusy => _isBusy 값을 셋팅한다.
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;

      if (_isBusy == false) notifyListeners();
    }
  }

  // _pageIndex =>
  int _pageIndex = 0;

  // pageIndex => _pageIndex 값을 받아온다.
  int get pageIndex {
    return _pageIndex;
  }

  // setPageIndex => _pageIndex 값을 셋팅한다.
  set setpageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}
