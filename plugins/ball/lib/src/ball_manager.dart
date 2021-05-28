import 'dart:collection';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'ball_model.dart';

class PositionWithTime {
  Offset position;
  int time;

  PositionWithTime(this.position, this.time);
}

class BallManager extends ChangeNotifier implements TickerProvider {
  BallManager([this.conf]) {
    if (conf == null) {
      conf = BallCf();
    }
  }

  List<Point> points = [];

  AnimationController controller;
  Animation<double> animation;
  double currentRadian = 0;

  Random random = Random();

  BallCf conf;

  /// 当前的旋转轴 [当添加手势的修改]
  Point axisVector;
  Offset lastPosition;
  Offset downPosition;
  int lastHitTime = 0;
  Queue<PositionWithTime> queue = Queue();

  initState() {
    axisVector = getAxisVector(Offset(2, -1));
    //动画
    controller =
        AnimationController(duration: Duration(seconds: 40), vsync: this);

    animation = Tween(begin: 0.0, end: pi * 2).animate(controller);

    animation.addListener(() {
      tick(animation.value - currentRadian);
      currentRadian = animation.value;
      notifyListeners();
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        currentRadian = 0;
        controller.forward(from: 0.0);
      }
    });
  }

  start() {
    controller?.forward();
  }

  void tick(double value) {
    for (int i = 0; i < points.length; i++) {
      rotatePoint(axisVector, points[i], value);
    }
  }

  // 计算字体大小
  double getFontSize(double z) {
    //点的z坐标为[-r,r]，对应文字的尺寸为[8,16]
    return 8 + 8 * (z + conf.radius) / (2 * conf.radius);
  }

  double getFontOpacity(double z) {
    //点的z坐标为[-r,r]，对应点的透明度为[0.5,1]
    return 0.5 + 0.5 * (z + conf.radius) / (2 * conf.radius);
  }

  ///计算点point绕轴axis旋转radian弧度后的点坐标
  ///计算依据：罗德里格旋转矢量公式
  void rotatePoint(
    Point axis,
    Point point,
    double radian,
  ) {
    double x = cos(radian) * point.x +
        (1 - cos(radian)) *
            (axis.x * point.x + axis.y * point.y + axis.z * point.z) *
            axis.x +
        sin(radian) * (axis.y * point.z - axis.z * point.y);

    double y = cos(radian) * point.y +
        (1 - cos(radian)) *
            (axis.x * point.x + axis.y * point.y + axis.z * point.z) *
            axis.y +
        sin(radian) * (axis.z * point.x - axis.x * point.z);

    double z = cos(radian) * point.z +
        (1 - cos(radian)) *
            (axis.x * point.x + axis.y * point.y + axis.z * point.z) *
            axis.z +
        sin(radian) * (axis.x * point.y - axis.y * point.x);

    point.x = x;
    point.y = y;
    point.z = z;
  }

  /// 绘制每一个点
  void generatePoints(List<BasePointModel> keywords) {
    points.clear();
    //将2pi分为keywords.length等份
    double dAngleStep = 2 * pi / keywords.length;

    for (int i = 0; i < keywords.length; i++) {
      BasePointModel item = keywords[i];
      // 极坐标方位角
      double dAngle = dAngleStep * i;
      // 仰角
      double eAngle =
          (AxisCenter[i % 10] + (random.nextDouble() - 0.5) / 10) * pi;

      // 球极坐标转为直角坐标
      double x = conf.radius * sin(eAngle) * sin(dAngle);
      double y = conf.radius * cos(eAngle);
      double z = conf.radius * sin(eAngle) * cos(dAngle);

      Point point = Point(x, y, z);
      point.model = item;
      point.paragraphs = [];

      // 每 3个 z生成一个paragraphs，节省内存
      for (double z = -conf.radius; z <= conf.radius; z += 3) {
        double fs = getFontSize(z);
        point.paragraphs.add(buildText(point: point, z: z, fontSize: fs));
      }
      points.add(point);
    }
    notifyListeners();
    start();
  }

  ui.Paragraph buildText({Point point, num z, double fontSize}) {
    String text = point.model.title;
    if (text.length > conf.maxShowLength) {
      String firstLine = text.substring(0, 5);
      String secondLine = text.substring(5);
      if (secondLine.length > conf.maxShowLength) {
        secondLine = secondLine.substring(0, 4) + "...";
      }
      text = "$firstLine\n$secondLine";
    }

    ui.ParagraphBuilder paragraphBuilder =
        ui.ParagraphBuilder(ui.ParagraphStyle());

    double op = getFontOpacity(z.toDouble());
    conf.labelColor = conf.labelColor.withOpacity(op);
    conf.selectedLabelColor = conf.selectedLabelColor.withOpacity(op);
    paragraphBuilder.pushStyle(
      ui.TextStyle(
          fontSize: fontSize,
          color: point.model.isHigh ? conf.selectedLabelColor : conf.labelColor,
          height: 1.0,
          shadows: point.model.isHigh
              ? [
                  Shadow(
                    color: conf.selectedLabelColor,
                    offset: Offset(0, 0),
                    blurRadius: 10,
                  )
                ]
              : []),
    );
    paragraphBuilder.addText(text);

    ui.Paragraph paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 2.0 * conf.radius));
    return paragraph;
  }

  // 获取随机颜色
  Color randomRGB({
    int limitR = 0,
    int limitG = 0,
    int limitB = 0,
  }) {
    var r = limitR + random.nextInt(256 - limitR); //红值
    var g = limitG + random.nextInt(256 - limitG); //绿值
    var b = limitB + random.nextInt(256 - limitB); //蓝值
    return Color.fromARGB(255, r, g, b); //生成argb模式的颜色
  }

  handlerPointDown(PointerDownEvent event) {
    int now = DateTime.now().millisecondsSinceEpoch;
    downPosition = convertCoordinate(event.localPosition);
    lastPosition = convertCoordinate(event.localPosition);

    //速度跟踪队列
    clearQueue();
    addToQueue(PositionWithTime(downPosition, now));

    controller.stop();
  }

  handlerPointMove(PointerMoveEvent event) {
    int now = DateTime.now().millisecondsSinceEpoch;
    Offset currentPosition = convertCoordinate(event.localPosition);
    addToQueue(PositionWithTime(currentPosition, now));

    Offset delta = Offset(currentPosition.dx - lastPosition.dx,
        currentPosition.dy - lastPosition.dy);

    double distance = sqrt(delta.dx * delta.dx + delta.dy * delta.dy);
    //若计算量级太小，框架内部会报精度溢出的错误
    if (distance > 2) {
      //旋转点
      lastPosition = currentPosition;

      //球体应该旋转的弧度角度 = 距离/radius
      double radian = distance / conf.radius;
      //旋转轴
      axisVector = getAxisVector(delta);
      //更新点的位置
      for (int i = 0; i < points.length; i++) {
        rotatePoint(axisVector, points[i], radian);
      }

      notifyListeners();
    }
  }

  handlerPointUp(PointerUpEvent event) {
    int now = DateTime.now().millisecondsSinceEpoch;
    Offset upPosition = convertCoordinate(event.localPosition);
    addToQueue(PositionWithTime(upPosition, now));

    // 检测是否是fling手势
    Offset velocity = getVelocity();

    // 速度模量>=1就认为是fling手势
    if (sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy) >= 1) {
      //开始fling动画
      currentRadian = 0;
      controller.fling();
    } else {
      //开始匀速动画
      currentRadian = 0;
      controller.forward(from: 0.0);
    }

    /// 检测点击事件
    double distanceSinceDown = sqrt(pow(upPosition.dx - downPosition.dx, 2) +
        pow(upPosition.dy - downPosition.dy, 2));
    //按下和抬起点的距离小于4，认为是点击事件
    if (distanceSinceDown < 8) {
      //寻找命中的point
      int searchRadiusW = 30;
      int searchRadiusH = 10;

      for (int i = 0; i < points.length; i++) {
        //points[i].z >= 0：只在球正面的点中寻找
        Point point = points[i];
        if (point.z >= 0 &&
            (upPosition.dx - point.x).abs() < searchRadiusW &&
            (upPosition.dy - point.y).abs() < searchRadiusH) {
          int now = DateTime.now().millisecondsSinceEpoch;
          //防止双击
          if (now - lastHitTime > 2000) {
            lastHitTime = now;

            // 创建点选中动画序列
            point.pointAnimationSequence = PointAnimationSequence(point, this);
            //跳转页面
            Future.delayed(Duration(milliseconds: 500), () {
              print("点击“${point.model.title}”");
              point.model.cb(point.model);
            });
          }
          break;
        }
      }
    }
  }

  /// 开始匀速动画
  handlerPointCancel(_) {
    currentRadian = 0;
    controller.forward(from: 0.0);
  }

  /// 将绘图坐标系中的坐标转换为3d模型坐标系中的坐标
  Offset convertCoordinate(Offset offset) {
    return Offset(offset.dx - conf.radius, conf.radius - offset.dy);
  }

  ///清空队列
  void clearQueue() {
    queue.clear();
  }

  ///添加跟踪点
  void addToQueue(PositionWithTime p) {
    int lengthOfQueue = 5;
    if (queue.length >= lengthOfQueue) {
      queue.removeFirst();
    }
    queue.add(p);
  }

  ///由旋转矢量得到旋转轴方向的单位矢量
  ///将旋转矢量(x,y)逆时针旋转90度即可
  ///x2 = xcos(pi/2)-ysin(pi/2)
  ///y2 = xsin(pi/2)+ycos(pi/2)
  Point getAxisVector(Offset scrollVector) {
    double x = -scrollVector.dy;
    double y = scrollVector.dx;
    double module = sqrt(x * x + y * y);
    return Point(x / module, y / module, 0);
  }

  ///计算速度
  ///速度单位：像素/毫秒
  Offset getVelocity() {
    Offset ret = Offset.zero;

    if (queue.length >= 2) {
      PositionWithTime first = queue.first;
      PositionWithTime last = queue.last;
      ret = Offset(
        (last.position.dx - first.position.dx) / (last.time - first.time),
        (last.position.dy - first.position.dy) / (last.time - first.time),
      );
    }

    return ret;
  }

  @override
  Ticker createTicker(void Function(Duration elapsed) onTick) {
    return Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
  }
}
