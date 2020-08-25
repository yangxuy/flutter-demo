import 'package:flutter/animation.dart';
import 'package:yx_demo/base_ext/model_ext.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';

class AnimationMC extends BaseModelLogic with SingleTickerProviderModelMixin {
  Animation animation;
  AnimationController controller;

  @override
  init(arguments) {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = controller.drive(Tween(begin: 10.0, end: 100.0));
  }
}
