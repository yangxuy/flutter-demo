import 'dart:collection';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'ball_manager.dart';

typedef PointCb = Function(BasePointModel);

const List<double> AxisCenter = [
  0.5,
  0.35,
  0.65,
  0.35,
  0.2,
  0.5,
  0.65,
  0.35,
  0.65,
  0.8
];

class PointAnimationSequence {
  Point point;
  Queue<ui.Paragraph> paragraphs;
  BallManager pm;

  PointAnimationSequence(this.point, this.pm) {
    paragraphs = Queue();

    double fontSize = pm.getFontSize(point.z);
    // 字号从fontSize变化到22
    for (double fs = fontSize; fs <= 22; fs += 1) {
      paragraphs.addLast(pm.buildText(point: point, z: point.z, fontSize: fs));
    }
    //字号从22变化到fontSize
    for (double fs = 22; fs >= fontSize; fs -= 1) {
      paragraphs.addLast(pm.buildText(point: point, z: point.z, fontSize: fs));
    }
  }
}

class Point {
  double x, y, z;
  BasePointModel model;
  List<ui.Paragraph> paragraphs; // 对应每一个位置生成一个 目前是每3个单位生成一个
  //手指按下时命中的point
  PointAnimationSequence pointAnimationSequence;

  Point(
    this.x,
    this.y,
    this.z, {
    this.model,
  });

  //z取值[-radius,radius]时的paragraph，依次存储在paragraphs中
  //每3个z生成一个paragraphs
  getParagraph(double radius) {
    int index = (z + radius).round() ~/ 3;
    return paragraphs[index];
  }
}

class BasePointModel {
  String title;
  int id;
  bool isHigh;
  dynamic data;
  PointCb cb;

  BasePointModel({
    this.title,
    this.id,
    this.data,
    this.isHigh = false,
    this.cb,
  });
}

class BallCf {
  double radius;
  Color labelColor;
  Color selectedLabelColor;
  Color indicatorColor;
  Color selectedIndicatorColor;
  int maxShowLength;

  BallCf({
    this.indicatorColor,
    this.selectedIndicatorColor,
    this.radius = 150.0,
    this.labelColor = Colors.black,
    this.selectedLabelColor = Colors.greenAccent,
    this.maxShowLength = 5,
  });
}
