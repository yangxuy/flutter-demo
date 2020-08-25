import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';

class CarouselMC extends BaseModelLogic {
  double aspectRatio = 2.5;
  double viewportFraction = 1.0;
  double scale = 1.0;
  bool auto = false;
  PageController controller;
  Duration duration = Duration(seconds: 1);
  List<String> img = [];
  List<String> imgUrl = [];
  int currentIndex;

  init(arg) {
    aspectRatio = arg['aspectRatio'];
    viewportFraction = arg['viewportFraction'];
    img = arg['img'];
    imgUrl
      ..add(img.last)
      ..addAll(img)
      ..add(img.first);
    controller = PageController(viewportFraction: viewportFraction);
    if (auto) {
      setTimer();
    }
  }

  Timer timer;

  setTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      controller.animateToPage(currentIndex + 1,
          duration: duration, curve: Curves.easeOut);
    });
  }

  builderItem(String url) {
    if (scale < 1.0) {

    } else {
      return Container(
        margin: EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.asset(
            url,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
