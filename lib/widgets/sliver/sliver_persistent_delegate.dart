import 'dart:math' as math;
import 'package:flutter/material.dart';

/*----------------------------------------------------------------
  - 클래스 : SliverAppBarDelegate
  - 기능  : 고정헤더 (searchBar를 고정하기위함)
  - @param {} 
  - @return {} 
  - 이력 : 2022.08.03 / 김종환 / 최초생성 
  ----------------------------------------------------------------*/

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  SliverPersistentDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverPersistentDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
