import 'package:flutter/material.dart';

class CanvasIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('canvas'),
      ),
      body: Container(
        width: 100,
        height: 40,
        color: Colors.blue,
        child: CustomPaint(
          painter: IndexPainter(),
        ),
      ),
    );
  }
}

class IndexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text:
          "城市的霓虹灯总是在夜晚还没有降临的时候就早早亮起，仿佛是在显示着与农村的不同之处，",
      style: TextStyle(color: Colors.red,fontSize: 14),
    );
    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset.zero);
    var end = textPainter
        .getPositionForOffset(Offset(size.width, size.height))
        .offset;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
