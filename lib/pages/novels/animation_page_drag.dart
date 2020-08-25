import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'type.dart';

class AnimationPageDrag {
  static const PERCENT_PER_MILLISECOND = 0.001;

  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;

  AnimationController completionAnimationController;

  AnimationPageDrag({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamSink<SlideUpdate> percentSink,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    double endSlidePercent;
    Duration duration;
    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration = new Duration(
          milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round());
    } else {
      endSlidePercent = 0.0;
      duration = new Duration(
          milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    completionAnimationController =
        AnimationController(duration: duration, vsync: vsync)
          ..addListener(() {
            slidePercent = lerpDouble(
              startSlidePercent,
              endSlidePercent,
              completionAnimationController.value,
            );

            percentSink.add(SlideUpdate(
              UpdateType.animating,
              slideDirection,
              slidePercent,
            ));
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              percentSink.add(new SlideUpdate(
                UpdateType.doneAnimating,
                slideDirection,
                endSlidePercent,
              ));
            }
          });
  }

  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}
