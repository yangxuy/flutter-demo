import 'package:flutter/material.dart';
import '../../kline.dart';

class TimeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globalKlineBloc.currentKlineListStream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return CustomPaint(
            painter: TimePainter(candlerList: snapshot.data),
            child: Container(),
          );
        }
        return SizedBox();
      },
    );
  }
}

class TimePainter extends CustomPainter {
  final List<Market> candlerList;

  TimePainter({this.candlerList});

  @override
  void paint(Canvas canvas, Size size) {
    double averageColumn =
        size.width / globalKlineBloc.configuration.kGridColumnCount;
    for (int i = 0; i < globalKlineBloc.configuration.kGridColumnCount; i++) {
      int index = averageColumn *
          i ~/
          (globalKlineBloc.candlestickWidth +
              globalKlineBloc.configuration.kCandlestickGap);
      if (index < candlerList.length) {
        int timestamp = candlerList[index].id;
        String date = showTimestamp(timestamp * 1000);
        TextPainter textPainter = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(
              text: date,
              style: TextStyle(
                color: globalKlineBloc.configuration.kTimeCandleTextColor,
                fontSize: globalKlineBloc.configuration.kTimeCandleFontSize,
              ),
            ))
          ..layout();
        Offset offset = Offset(averageColumn * i, textPainter.size.height);
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(TimePainter oldDelegate) {
    return false;
  }
}
