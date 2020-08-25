import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:novel/novel.dart';
import 'package:yx_demo/http/mock_api.dart';
import 'package:yx_demo/screen/screen.dart';

import 'reader_utils.dart';
import 'type.dart';

fixedFontSize(double fontSize) {
  return fontSize / Screen.textScaleFactor;
}

Widget handlerBuildBg() {
  return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: Image.asset('assets/images/read_bg.png', fit: BoxFit.cover));
}

class DragNovel extends StatefulWidget {
  @override
  _DragNovelState createState() => _DragNovelState();
}

class _DragNovelState extends State<DragNovel> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;

  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;
  Section section;
  double fontSize = 20;

  @override
  void initState() {
    super.initState();
    slideUpdateStream = new StreamController<SlideUpdate>();
    slideUpdateStream.stream.listen((SlideUpdate event) {
      if (event.updateType == UpdateType.dragging) {
        print('Sliding ${event.direction} at ${event.slidePercent}');
        slideDirection = event.direction;
        slidePercent = event.slidePercent;

        if (slideDirection == SlideDirection.leftToRight) {
          nextPageIndex = activeIndex - 1;
        } else if (slideDirection == SlideDirection.rightToLeft) {
          nextPageIndex = activeIndex + 1;
        } else {
          nextPageIndex = activeIndex;
        }
      } else if (event.updateType == UpdateType.doneDragging) {
        if (slidePercent > 0.2) {
          animatedPageDragger = new AnimatedPageDragger(
            slideDirection: slideDirection,
            transitionGoal: TransitionGoal.open,
            slidePercent: slidePercent,
            slideUpdateStream: slideUpdateStream,
            vsync: this,
          );
        } else {
          animatedPageDragger = new AnimatedPageDragger(
            slideDirection: slideDirection,
            transitionGoal: TransitionGoal.close,
            slidePercent: slidePercent,
            slideUpdateStream: slideUpdateStream,
            vsync: this,
          );
          nextPageIndex = activeIndex;
        }
        animatedPageDragger.run();
      } else if (event.updateType == UpdateType.animating) {
        print('Sliding ${event.direction} at ${event.slidePercent}');
        slideDirection = event.direction;
        slidePercent = event.slidePercent;
      } else if (event.updateType == UpdateType.doneAnimating) {
        print('Done animating. Next page index: $nextPageIndex');
        activeIndex = nextPageIndex;

        slideDirection = SlideDirection.none;
        slidePercent = 0.0;

        animatedPageDragger.dispose();
      }
      setState(() {});
    });
    initData();
  }

  initData() async {
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
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    if (section == null) {
      return Scaffold();
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          handlerBuildBg(),
          NovelPage(section.stringAtPageIndex(nextPageIndex), fontSize,
              nextPageIndex),
          PageReveal(
            revealPercent: slidePercent,
            slideDirection: slideDirection,
            child: NovelPage(
                section.stringAtPageIndex(activeIndex), fontSize, activeIndex),
          ),
          PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < section.pageOffsets.length - 1,
            slideUpdateStream: slideUpdateStream,
          )
        ],
      ),
    );
  }
}

class NovelPage extends StatelessWidget {
  final String content;
  final double fontSize;
  final int page;

  NovelPage(this.content, this.fontSize, this.page);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        handlerBuildBg(),
        Container(
          margin: EdgeInsets.fromLTRB(
              15,
              Screen.topSafeHeight + ReaderUtils.topOffset,
              10,
              Screen.bottomSafeHeight + ReaderUtils.bottomOffset),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: content,
                  style: TextStyle(fontSize: fixedFontSize(fontSize)))
            ]),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: 15,
              right: Screen.topSafeHeight + ReaderUtils.topOffset + 10,
              top: 15,
              bottom: Screen.bottomSafeHeight + ReaderUtils.bottomOffset - 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('测试',
                  style: TextStyle(
                    fontSize: 14,
                  )),
              Expanded(child: Container()),
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Text('10:10',
                      style: TextStyle(
                        fontSize: 11,
                      )),
                  Expanded(child: Container()),
                  Text(
                    '第$page页',
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;
  final SlideDirection slideDirection;

  PageReveal({
    this.revealPercent,
    this.child,
    this.slideDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(
          slideDirection == SlideDirection.leftToRight
              ? revealPercent * Screen.width
              : -revealPercent * Screen.width,
          0,
          0),
      child: Transform(
        transform: Matrix4.rotationY(0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(4, 4),
                blurRadius: 4)
          ]),
          child: child,
        ),
      ),
    );
  }
}

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger({
    this.canDragLeftToRight,
    this.canDragRightToLeft,
    this.slideUpdateStream,
  });

  @override
  _PageDraggerState createState() => new _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(
          new SlideUpdate(UpdateType.dragging, slideDirection, slidePercent));
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(new SlideUpdate(
      UpdateType.doneDragging,
      SlideDirection.none,
      0.0,
    ));

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

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
        new AnimationController(duration: duration, vsync: vsync)
          ..addListener(() {
            slidePercent = lerpDouble(
              startSlidePercent,
              endSlidePercent,
              completionAnimationController.value,
            );

            slideUpdateStream.add(new SlideUpdate(
              UpdateType.animating,
              slideDirection,
              slidePercent,
            ));
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream.add(new SlideUpdate(
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
