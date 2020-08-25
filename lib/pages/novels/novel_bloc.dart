import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yx_demo/http/mock_api.dart';
import 'package:yx_demo/screen/screen.dart';

import 'animation_page_drag.dart';
import 'animation_page_menu.dart';
import 'type.dart';

import 'package:yx_demo/bloc/bloc.dart';

class Content {
  Content();

  factory Content._current(String section, int page) = CurrentContent;

  factory Content._next(String section, int page) = NextContent;
}

class CurrentContent extends Content {
  final String content;
  final int page;

  CurrentContent(this.content, this.page);
}

class NextContent extends Content {
  final String content;
  final int page;

  NextContent(this.content, this.page);
}

class NovelBloc extends BaseBloc with SingleTickerProviderModelMixin {
  StreamController<Section> _sectionController = BehaviorSubject<Section>();

  Stream<Section> get sectionStream => _sectionController.stream;

  StreamSink<Section> get sectionSink => _sectionController.sink;

  StreamController<SlideUpdate> _percentController =
      BehaviorSubject<SlideUpdate>();

  Stream<SlideUpdate> get percentStream => _percentController.stream;

  StreamSink<SlideUpdate> get percentSink => _percentController.sink;

  // fontSize
  StreamController<double> _fontSizeController = BehaviorSubject<double>();

  Stream<double> get fontSizeStream => _fontSizeController.stream;

  StreamSink<double> get fontSizeSink => _fontSizeController.sink;

  /// 内容[Content]
  StreamController<Content> _contentController = BehaviorSubject<Content>();

  Stream<Content> get contentStream => _contentController.stream;

  StreamSink<Content> get contentSink => _contentController.sink;

  ReadType readType = ReadType.cover;

  int curIndex = 0;
  int nextIndex = 0;

  int articleId = 1000;

  Section section;

  //布局相关
  double fontSize = 18.0;
  double topOffset = 37;
  double bottomOffset = 37;
  double leftOffset = 15;
  double rightOffset = 10;
  double contentHeight = 0.0;
  double contentWidth = 0.0;

  // 事件相关
  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent;
  bool canDragRightToLeft;
  bool canDragLeftToRight;

  // 颜色
  String urlBg = 'assets/images/read_bg.png';
  Color golden = Color(0xff8B7961);

  // 动画相关
  AnimationPageDrag animationPageDrag;
  AnimationPageMenu animationPageMenu;
  Animation<Offset> rectTop;
  Animation<Offset> rectBottom;

  double get fontScaleSize {
    return fixedFontSize(fontSize);
  }

  setContent(BuildContext context) {
    contentHeight = MediaQuery.of(context).size.height -
        topOffset -
        bottomOffset -
        fixedFontSize(fontSize);

    contentWidth = MediaQuery.of(context).size.width - leftOffset - rightOffset;
  }

  initState() async {
    animationPageMenu = AnimationPageMenu(vsync: this);
    var response = await Request.get(action: 'article_$articleId');
    section = Section.fromJson(response);
    handlerData(section);
  }

  handlerData(Section section) {
    section.pageOffsets =
        getPageOffsets(section.content, contentHeight, contentWidth, fontSize);
    sectionSink.add(section);
    handlerSectionStream();
  }

  handlerSectionStream() {
    String content = section.stringAtPageIndex(curIndex);
    contentSink.add(Content._current(content, curIndex));
  }

  onTapUp(TapUpDetails details) {
    Offset position = details.globalPosition;
    double rate = position.dx / contentWidth;
    if (rate > 0.3 && rate < 0.6) {
      animationPageMenu.show();
    }
  }

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    canDragRightToLeft = curIndex < section.pageOffsets.length - 1;
    canDragLeftToRight = curIndex > 0;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / contentWidth).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      percentSink
          .add(SlideUpdate(UpdateType.dragging, slideDirection, slidePercent));
    }
  }

  onDragEnd(DragEndDetails details) {
    dragStart = null;
    percentSink.add(
        SlideUpdate(UpdateType.doneDragging, slideDirection, slidePercent));
  }

  handlerNextContent(SlideUpdate event) {
    if (event.updateType == UpdateType.dragging) {
      if (slideDirection == SlideDirection.leftToRight) {
        nextIndex = curIndex - 1;
      } else if (slideDirection == SlideDirection.rightToLeft) {
        nextIndex = curIndex + 1;
      } else {
        nextIndex = curIndex;
      }

      String content = section.stringAtPageIndex(nextIndex);
      contentSink.add(Content._next(content, nextIndex));
    } else if (event.updateType == UpdateType.doneDragging) {
      if (slidePercent > 0.2) {
        animationPageDrag = AnimationPageDrag(
          slideDirection: slideDirection,
          transitionGoal: TransitionGoal.open,
          slidePercent: slidePercent,
          percentSink: percentSink,
          vsync: this,
        );
      } else {
        animationPageDrag = AnimationPageDrag(
          slideDirection: slideDirection,
          transitionGoal: TransitionGoal.close,
          slidePercent: slidePercent,
          percentSink: percentSink,
          vsync: this,
        );
        nextIndex = curIndex;
      }
      animationPageDrag.run();
    } else if (event.updateType == UpdateType.animating) {
//      print('Sliding ${event.direction} at ${event.slidePercent}');
//      slideDirection = event.direction;
//      slidePercent = event.slidePercent;
    } else if (event.updateType == UpdateType.doneAnimating) {
      curIndex = nextIndex;
      slideDirection = SlideDirection.none;
      slidePercent = 0.0;
      handlerSectionStream();
      animationPageDrag.dispose();
    }
  }

  static List<Map<String, int>> getPageOffsets(
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

  @override
  dispose() {
    _percentController.close();
    _sectionController.close();
    _fontSizeController.close();
    _contentController.close();
  }
}
