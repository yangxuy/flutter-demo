import 'package:flutter/material.dart';
import '../../kline.dart';

class CandleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Market>>(
      stream: globalKlineBloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return CustomPaint(
            child: Container(),
            painter: CandlePainter(
              candlerList: snapshot.data,
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

class CandlePainter extends CustomPainter {
  final List<Market> candlerList;
  Paint deCreasePainter;
  Paint inCreasePainter;

  CandlePainter({this.candlerList}) {
    deCreasePainter = Paint()
      ..color = Color(0xFFE66363)
      ..strokeWidth = globalKlineBloc.configuration.kWickWidth;
    inCreasePainter = Paint()
      ..color = Color(0xFF00B984)
      ..strokeWidth = globalKlineBloc.configuration.kWickWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    globalKlineBloc.setKBox(size);
    double height = size.height - globalKlineBloc.configuration.kTopMargin;
    for (int i = 0; i < candlerList.length; i++) {
      double left = i *
          (globalKlineBloc.candlestickWidth +
              globalKlineBloc.configuration.kCandlestickGap);

      double right = left + globalKlineBloc.candlestickWidth;

      if (candlerList[i].open > candlerList[i].close) {
        /// 升
        double top = height -
            (candlerList[i].open - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;

        double bottom = height -
            (candlerList[i].close - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;
        Rect rect = Rect.fromLTRB(left, top, right, bottom);
        canvas.drawRect(rect, deCreasePainter);

        //todo: 画烛台的high
        double dx = left + globalKlineBloc.candlestickWidth / 2;
        double hY = height -
            (candlerList[i].high - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;

        Offset p1 = Offset(dx, hY);
        Offset p2 = Offset(dx, top);
        canvas.drawLine(p1, p2, deCreasePainter);

        //todo: 画烛台的low
        double lY = height -
            (candlerList[i].low - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;
        Offset p3 = Offset(dx, lY);
        Offset p4 = Offset(dx, bottom);
        canvas.drawLine(p3, p4, deCreasePainter);
      } else {
        ///跌
        double top = height -
            (candlerList[i].close - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;
        double bottom = height -
            (candlerList[i].open - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;
        Rect rect = Rect.fromLTRB(left, top, right, bottom);
        canvas.drawRect(rect, inCreasePainter);

        //todo: 画烛台的high和low
        double dx = left + globalKlineBloc.candlestickWidth / 2;
        double hY = height -
            (candlerList[i].high - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;
        Offset p1 = Offset(dx, hY);
        Offset p2 = Offset(dx, top);
        canvas.drawLine(p1, p2, inCreasePainter);

        //todo: 画烛台的low
        double lY = height -
            (candlerList[i].low - globalKlineBloc.priceMin) *
                globalKlineBloc.candleHeightAverage +
            globalKlineBloc.configuration.kTopMargin;

        Offset p3 = Offset(dx, lY);
        Offset p4 = Offset(dx, bottom);

        canvas.drawLine(p3, p4, inCreasePainter);
      }
    }
  }

  @override
  bool shouldRepaint(CandlePainter oldDelegate) {
    return false;
  }
}
