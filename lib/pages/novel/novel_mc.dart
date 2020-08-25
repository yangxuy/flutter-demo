import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx_demo/base_ext/model_ext.dart';
import 'package:yx_demo/http/mock_api.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';
import 'package:novel/novel.dart';
import 'package:yx_demo/screen/screen.dart';

import 'reader_utils.dart';
import 'type.dart';

class NovelMC extends BaseModelLogic with SingleTickerProviderModelMixin {
  Section section;
  double fontSize = 18;
  PageController pageController;
  double topSafeHeight = 0.0;
  Color golden = Color(0xff8B7961);
  AnimationController controller;
  Animation<Offset> aniTop;
  Animation<Offset> aniBottom;
  int type = 1;

  // 翻页模式
  int currentIndex = 0;
  int nextIndex = 1;
  double slidePercent = 0.0;
  SlideDirection slideDirection;
  StreamController<SlideUpdate> slideUpdateStream;
  @override
  init(arguments) async {
    pageController = PageController();
    await SystemChrome.setEnabledSystemUIOverlays([]);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: golden,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    await Future.delayed(const Duration(milliseconds: 100), () {});
    topSafeHeight = Screen.topSafeHeight;

    section = await SectionApi.fetchSection(1000);
    var contentHeight = Screen.height -
        Screen.topSafeHeight -
        Screen.bottomSafeHeight -
        ReaderUtils.topOffset -
        ReaderUtils.bottomOffset -
        fixedFontSize(fontSize);

    var contentWidth = Screen.width - 15 - 10;

    section.pageOffsets =
        getPageOffsets(section.content, contentHeight, contentWidth, fontSize);

    controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    aniTop = controller
        .drive(Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)));

    aniBottom =
        controller.drive(Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)));

    slideUpdateStream = new StreamController<SlideUpdate>();
    slideUpdateStream.stream.listen((SlideUpdate event) {
      slidePercent = event.slidePercent;
      notify();
    });
    notify();
  }

  // 划分章节
  List<Map<String, int>> getPageOffsets(
      String content, double height, double width, double fontSize) {
    String tempStr = content;
    List<Map<String, int>> pageConfig = [];
    int last = 0;
    while (true) {
      Map<String, int> offset = {};
      offset['start'] = last;
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text =
          TextSpan(text: tempStr, style: TextStyle(fontSize: fontSize));
      textPainter.layout(maxWidth: width);

      var end = textPainter.getPositionForOffset(Offset(width, height)).offset;

      if (end == 0) {
        break;
      }
      tempStr = tempStr.substring(end, tempStr.length);
      offset['end'] = last + end;
      last = last + end;
      pageConfig.add(offset);
    }
    return pageConfig;
  }

  fixedFontSize(double fontSize) {
    return fontSize / Screen.textScaleFactor;
  }

  onPageChanged(int index) {}

  handlerClickView(Offset position) {
    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
      if (controller.status == AnimationStatus.completed) {
        SystemChrome.setEnabledSystemUIOverlays([]);
        controller.reverse();
      } else {
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
        controller.forward();
      }
    } else if (xRate >= 0.66) {
      // nextPage();
    } else {
      // previousPage();
    }
  }

  handlerSlide(SlideUpdate event) {
    if (event.updateType == UpdateType.dragging) {
      print('Sliding ${event.direction} at ${event.slidePercent}');
      slidePercent = event.slidePercent;
      notify();
    }
  }

  @override
  dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}
