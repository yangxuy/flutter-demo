import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class XScrollPositionWithSingleContext extends ScrollPosition implements ScrollActivityDelegate {

  XScrollPositionWithSingleContext({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    double initialPixels = 0.0,
    bool keepScrollOffset = true,
    ScrollPosition oldPosition,
    String debugLabel,
  }) : super(
    physics: physics,
    context: context,
    keepScrollOffset: keepScrollOffset,
    oldPosition: oldPosition,
    debugLabel: debugLabel,
  ) {
    // If oldPosition is not null, the superclass will first call absorb(),
    // which may set _pixels and _activity.
    if (pixels == null && initialPixels != null)
      correctPixels(initialPixels);
    if (activity == null)
      goIdle();
    assert(activity != null);
  }

  @override
  Future<void> animateTo(double to, {Duration duration, Curve curve}) {
    // TODO: implement animateTo
    throw UnimplementedError();
  }

  @override
  void applyUserOffset(double delta) {
    // TODO: implement applyUserOffset
  }

  @override
  // TODO: implement axisDirection
  AxisDirection get axisDirection => throw UnimplementedError();

  @override
  Drag drag(DragStartDetails details, dragCancelCallback) {
    // TODO: implement drag
    throw UnimplementedError();
  }

  @override
  void goBallistic(double velocity) {
    // TODO: implement goBallistic
  }

  @override
  void goIdle() {
    beginActivity(IdleScrollActivity(this));
  }

  @override
  ScrollHoldController hold(holdCancelCallback) {
    // TODO: implement hold
    throw UnimplementedError();
  }

  @override
  void jumpTo(double value) {
    // TODO: implement jumpTo
  }

  @override
  void jumpToWithoutSettling(double value) {
    // TODO: implement jumpToWithoutSettling
  }

  @override
  // TODO: implement userScrollDirection
  ScrollDirection get userScrollDirection => throw UnimplementedError();
}