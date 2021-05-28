import 'package:flutter/material.dart';
import 'package:kline/kline.dart';

class ScrollWidget extends StatefulWidget {
  @override
  _ScrollWidgetState createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  double _maxScrollLength = 0;
  ScrollController _scrollController;
  ///缩放比例
  double scale = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      int scrollIndex = _scrollController.offset ~/
          (globalKlineBloc.candlestickWidth +
              globalKlineBloc.configuration.kCandlestickGap);

      globalKlineBloc.getSubKlineList(increase: scrollIndex);
    });
  }

  /// 每次修改最大数量的时候 重新 build
  _handlerCalculateScrollLength() {
    if (globalKlineBloc.firstScreenCandleCount >
        globalKlineBloc.klineTotalList.length) {
      _maxScrollLength = globalKlineBloc.width;
    } else {
      _maxScrollLength = (globalKlineBloc.candlestickWidth +
                  globalKlineBloc.configuration.kCandlestickGap) *
              (globalKlineBloc.klineTotalList.length + 1) +
          globalKlineBloc.columnGap;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 手势包含 点击 滑动
    return GestureDetector(
      ///缩放
      onScaleUpdate: (ScaleUpdateDetails details) {
        double candlestickWidth;
        if (details.scale - scale > 0.1) {
          ///放大
          candlestickWidth = globalKlineBloc.candlestickWidth + 1;
        } else if (details.scale - scale < -0.08) {
          ///缩小
          candlestickWidth = globalKlineBloc.candlestickWidth - 1;
        } else {
          return;
        }

        scale = details.scale;
        globalKlineBloc.setCandlestickWidth(candlestickWidth);

        globalKlineBloc.getSubKlineList(isScale: true);

      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        reverse: true,
        child: StreamBuilder(
          stream: globalKlineBloc.klineListSubjectStream,
          builder: (_, data) {
            if (data.connectionState == ConnectionState.active) {
              _handlerCalculateScrollLength();
              return Container(
                height: globalKlineBloc.height,
                width: _maxScrollLength,
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
