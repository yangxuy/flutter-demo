import 'package:flutter/material.dart';

class MenuAnimation extends StatefulWidget {
  final Widget child;

  MenuAnimation({this.child});

  @override
  _MenuAnimationState createState() => _MenuAnimationState();
}

class _MenuAnimationState extends State<MenuAnimation>
    with SingleTickerProviderStateMixin {
  // 动画相关 用于menu菜单
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 1400), vsync: this)
          ..addListener(() {
            setState(() {});
          })
          ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: animationController.value,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
