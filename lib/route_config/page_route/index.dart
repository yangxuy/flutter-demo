import 'package:flutter/material.dart';

/// 从下向上的路由动画
class SlideFromBottomPageBuilder extends PageRouteBuilder {
  Widget page;

  SlideFromBottomPageBuilder(this.page, {@required RouteSettings settings})
      : super(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
        );

  @override
  buildTransitions(_, ani1, ani2, child) {
    Animation<Offset> position =
        ani1.drive(Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)));
    return SlideTransition(
      position: position,
      child: child,
    );
  }
}

// 从右到左
class SlideFromRightPageBuilder extends PageRouteBuilder {
  Widget page;

  SlideFromRightPageBuilder(this.page, {@required RouteSettings settings})
      : super(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
        );

  @override
  buildTransitions(_, ani1, ani2, child) {
    Animation<Offset> position =
        ani1.drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)));
    return SlideTransition(
      position: position,
      child: child,
    );
  }
}

// 淡入淡出
class FadeInPageBuilder extends PageRouteBuilder {
  Widget page;
  FadeInPageBuilder(this.page, {RouteSettings settings})
      : super(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
