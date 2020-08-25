import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yx_demo/bloc/bloc.dart';

class CartoonChapter {
  String title;
  String subTitle;
  String chapter;
  List<String> chapterUrl;

  CartoonChapter({this.title, this.chapter, this.subTitle, this.chapterUrl});

  CartoonChapter.fromJson(Map map) {
    title = map['title'];
    subTitle = map['subTitle'];
    chapter = map['chapter'];
    chapterUrl = map['chapterUrl'];
  }

  factory CartoonChapter._preChapter(String title, String subTitle,
      String chapter, List<String> chapterUrl) = PreChapter;

  factory CartoonChapter._curChapter(String title, String subTitle,
      String chapter, List<String> chapterUrl) = CurCartoonChapter;

  factory CartoonChapter._nextChapter(String title, String subTitle,
      String chapter, List<String> chapterUrl) = NextCartoonChapter;
}

//前一话
class PreChapter extends CartoonChapter {
  PreChapter(
      String title, String subTitle, String chapter, List<String> chapterUrl)
      : super(
          title: title,
          subTitle: subTitle,
          chapter: chapter,
          chapterUrl: chapterUrl,
        );
}

// 当前话
class CurCartoonChapter extends CartoonChapter {
  CurCartoonChapter(
      String title, String subTitle, String chapter, List<String> chapterUrl)
      : super(
          title: title,
          subTitle: subTitle,
          chapter: chapter,
          chapterUrl: chapterUrl,
        );
}

// 下一话
class NextCartoonChapter extends CartoonChapter {
  NextCartoonChapter(
      String title, String subTitle, String chapter, List<String> chapterUrl)
      : super(
          title: title,
          subTitle: subTitle,
          chapter: chapter,
          chapterUrl: chapterUrl,
        );
}

class CartoonBloc extends BaseBloc with SingleTickerProviderModelMixin {
  ///控制菜单
  StreamController<bool> _menuController = BehaviorSubject<bool>();

  Stream<bool> get menuStream => _menuController.stream;

  Sink<bool> get menuSink => _menuController.sink;

  // 控制数据

  // 动画相关 用于menu菜单
  AnimationController animationController;
  Animation<Offset> rectTop;
  Animation<Offset> rectBottom;
  double starY;

  @override
  initState() {
    // 初始化动画相关
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    Tween<Offset> offsetTopTween = Tween(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    );
    Tween<Offset> offsetBottomTween = Tween(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    );
    rectTop = animationController.drive(offsetTopTween);
    rectBottom = animationController.drive(offsetBottomTween);

    initData();
  }

  initData() async {}

  onPointerUp(PointerUpEvent event) {
    double moveEnd = event.position.dy;

    ///判断是否是点击事件
    if ((moveEnd - starY).abs() < 10) {
      if (animationController.status == AnimationStatus.completed) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
    }
  }

  onPointerDown(PointerDownEvent event) {
    starY = event.position.dy;
  }

  showMenu() {
    menuSink.add(true);
  }

  @override
  dispose() {
    animationController.dispose();
    _menuController.close();
  }
}
