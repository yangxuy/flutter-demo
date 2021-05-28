import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'ball_manager.dart';
import 'ball_model.dart';

class BallDraw extends CustomPainter {
  final BallManager manager;
  Paint _paint;

  BallDraw({this.manager}) {
    _paint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (manager.points.isEmpty) return;
    manager.points.forEach((point) {
      drawParticle(canvas, point);
    });
  }

  void drawParticle(Canvas canvas, Point point) {
    List<double> xy = transformCoordinate(point);
    ui.Paragraph p;

    if (point.pointAnimationSequence != null &&
        point.pointAnimationSequence.point == point) {
      //动画未播放完毕
      if (point.pointAnimationSequence.paragraphs.isNotEmpty) {
        p = point.pointAnimationSequence.paragraphs.removeFirst();
        //动画已播放完毕
      } else {
        p = point.getParagraph(manager.conf.radius);
        point.pointAnimationSequence = null;
      }
    } else {
      p = point.getParagraph(manager.conf.radius);
    }

    //获得文字的宽高
    double halfWidth = p.minIntrinsicWidth / 2;
    double halfHeight = p.height / 2;

    canvas.drawParagraph(
      p,
      Offset(xy[0] - halfWidth, xy[1] - halfHeight),
    );
    _paint.color = point.model.isHigh
        ? manager.conf.selectedIndicatorColor
        : manager.conf.indicatorColor;
    canvas.drawCircle(
        Offset(xy[0], xy[1] + p.height), halfHeight * 2 / 3, _paint);
  }

  ///将3d模型坐标系中的坐标转换为绘图坐标系中的坐标
  ///x2 = r+x1;y2 = r-y1;
  List<double> transformCoordinate(Point point) {
    return [
      manager.conf.radius + point.x,
      manager.conf.radius - point.y,
      point.z
    ];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
