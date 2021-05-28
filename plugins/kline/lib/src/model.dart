import 'package:flutter/material.dart';

import '../kline.dart';

class KlineConfiguration {
  /// 网格配置
  Color lineColor = Color(0xff263347); // 表格画线颜色
  double kGridLineWidth = 0.5; // 表格画线宽度
  int kGridColumnCount = 5; // 网格纵向列数
  int kGridRowCount = 5; // 网格纵向列数
  int kGridPricePrecision = 7; // 小数精度
  /// 烛台配置
  double kCandlestickGap = 2.0; // 烛台的间距
  double kCandlestickWidth = 7.0; // 烛台宽度
  double kCandlestickWidthMax = 20.0; // 烛台最大宽度
  double kCandlestickWidthMin = 2.0; // 烛台最小宽度
  double kWickWidth = 1.0; // 烛台的画线宽度
  Color deCrease = Color(0xFFE66363);
  Color inCrease = Color(0xFF00B984);

  /// 间距配置
  double kTopMargin = 20.0;

  /// 文字配置
  Color kTimeCandleTextColor = Color(0xffCFD3E7);
  double kTimeCandleFontSize = 10.0;
}

class Market {
  Market(this.open, this.high, this.low, this.close, this.vol, this.id,
      {this.isShowCandleInfo});

  num open;
  num high;
  num low;
  num close;
  num vol;
  int id;

  //指标线数据
  double priceMa1;
  double priceMa2;
  double priceMa3;

  //todo: 交易价ma
  double volMa1;
  double volMa2;

  // 十字交叉点
  Offset offset;
  double candleWidgetOriginY;
  double gridTotalHeight;

  bool isShowCandleInfo;

  List<String> candleInfo() {
    double limitUpDownAmount = close - open;
    double limitUpDownPercent = (limitUpDownAmount / open) * 100;
    String pre = '';
    if (limitUpDownAmount < 0) {
      pre = '';
    } else if (limitUpDownAmount > 0) {
      pre = '+';
    }
    String limitUpDownAmountStr = '$pre${limitUpDownAmount.toStringAsFixed(2)}';
    String limitPercentStr = '$pre${limitUpDownPercent.toStringAsFixed(2)}%';
    return [
      ///时间
      readTimestamp(id),

      open.toStringAsPrecision(
          globalKlineBloc.configuration.kGridPricePrecision),
      high.toStringAsPrecision(
          globalKlineBloc.configuration.kGridPricePrecision),
      low.toStringAsPrecision(
          globalKlineBloc.configuration.kGridPricePrecision),
      close.toStringAsPrecision(
          globalKlineBloc.configuration.kGridPricePrecision),
      limitUpDownAmountStr,
      limitPercentStr,
      vol.toStringAsPrecision(globalKlineBloc.configuration.kGridPricePrecision)
    ];
  }

  void printDesc() {
    print(
        'open :$open close :$close high :$high low :$low vol :$vol offset: $offset');
  }
}

///时间转化
String readTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String time =
      '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  if (date.hour == 0 && date.minute == 0) {
    time =
        '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  return time;
}

///时间转化
String showTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
