import 'package:flutter/material.dart';
import 'package:kline/kline.dart';

class VolumeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globalKlineBloc.currentKlineListStream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var candleList = snapshot.data;
          return CustomPaint(
            child: Container(),
            painter: VolumePainter(
              candleList: candleList
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

class VolumePainter extends CustomPainter {
  final List<Market> candleList;
  Paint deCreasePainter;
  Paint inCreasePainter;

  VolumePainter({this.candleList}) {
    deCreasePainter = Paint()
      ..color = globalKlineBloc.configuration.deCrease
      ..strokeWidth = globalKlineBloc.configuration.kWickWidth;
    inCreasePainter = Paint()
      ..color = globalKlineBloc.configuration.inCrease
      ..strokeWidth = globalKlineBloc.configuration.kWickWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double averageVol = size.height / globalKlineBloc.volumeMax;
    for (int i = 0; i < candleList.length; i++) {
      double left = i *
          (globalKlineBloc.candlestickWidth +
              globalKlineBloc.configuration.kCandlestickGap);
      double right = left + globalKlineBloc.candlestickWidth;
      double top = size.height - candleList[i].vol * averageVol;
      Rect rect = Rect.fromLTRB(left, top, right, size.height);
      if (candleList[i].open > candleList[i].close) {
        canvas.drawRect(rect, deCreasePainter);
      } else {
        canvas.drawRect(rect, inCreasePainter);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
