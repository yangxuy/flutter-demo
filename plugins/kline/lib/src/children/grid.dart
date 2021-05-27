import 'package:flutter/material.dart';

import '../../kline.dart';

class GridWidget extends StatelessWidget {
  final bool isTop;

  GridWidget({this.isTop = true});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: GridPainter(isTop: isTop),
    );
  }
}

class GridPainter extends CustomPainter {
  final bool isTop;
  Paint gridPainter;

  GridPainter({this.isTop = true})
      : gridPainter = Paint()
          ..color = globalKlineBloc.configuration.lineColor
          ..strokeWidth = globalKlineBloc.configuration.kGridLineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    double averageColumn =
        size.width / globalKlineBloc.configuration.kGridColumnCount;

    double gapRow = size.height / globalKlineBloc.configuration.kGridRowCount;

    ///画横线
    if (isTop) {
      for (int i = 0; i < globalKlineBloc.configuration.kGridRowCount; i++) {
        Offset p1 = Offset(0, size.height - gapRow * i);
        Offset p2 = Offset(size.width, size.height - gapRow * i);
        canvas.drawLine(p1, p2, gridPainter);
      }
    } else {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), gridPainter);
      canvas.drawLine(
          Offset(0, size.height), Offset(size.width, size.height), gridPainter);
    }

    /// 画竖线
    for (int i = 0; i < globalKlineBloc.configuration.kGridColumnCount; i++) {
      Offset p1 = Offset(i * averageColumn, 0);
      Offset p2 = Offset(i * averageColumn, size.height);
      canvas.drawLine(p1, p2, gridPainter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
