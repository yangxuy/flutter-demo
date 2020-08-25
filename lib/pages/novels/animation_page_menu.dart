import 'package:flutter/material.dart';

class AnimationPageMenu {
  AnimationController _animationController;
  Animation<Offset> rectTop;
  Animation<Offset> rectBottom;

  AnimationPageMenu({
    TickerProvider vsync,
  }) {
    _animationController = AnimationController(
        vsync: vsync, duration: Duration(milliseconds: 400));
    Tween<Offset> offsetTopTween = Tween(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    );
    Tween<Offset> offsetBottomTween = Tween(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    );
    rectTop = _animationController.drive(offsetTopTween);
    rectBottom = _animationController.drive(offsetBottomTween);
  }

  show() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  dispose() {
    _animationController.dispose();
  }
}
