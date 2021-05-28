import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../kline.dart';
import '../kline.dart';
import 'kline_manager.dart';

class KlineBloc {
  double width;
  double height;

  /// 画布配置
  KlineConfiguration configuration = KlineConfiguration();

  ///总数据的传递
  StreamController<List<Market>> _klineListSubject;

  Sink<List<Market>> _klineListSubjectSink;

  Stream<List<Market>> klineListSubjectStream;

  ///当前数据的流入流出
  StreamController<List<Market>> _klineCurrentListSubject;

  Sink<List<Market>> _currentKlineListSink;

  Stream<List<Market>> currentKlineListStream;

  /// 总数据
  List<Market> klineTotalList = List();

  /// 单屏显示的kline数据
  List<Market> klineCurrentList = List();

  ///烛台的宽度-->缩放的时候 改变
  double candlestickWidth;

  /// 烛台能展示的最大值
  int screenCandleCount = 0;

  /// first烛台总数最大值
  int firstScreenCandleCount;

  /// 当前K线滑到的起点位置
  int fromIndex;

  /// 当前K线滑到的终点位置
  int toIndex;

  ///偏移量-->滑动产生
  int increase = 0;

  ///烛台高度占比
  double candleHeightAverage = 0;

  ///判断是否展示一屏
  double isFull = 0.0;

  double columnGap = 0;

  double priceMax = 0;
  double priceMin = 0;
  double pMax;
  double pMin;
  double volumeMax;

  dispose() {
    _currentKlineListSink.close();
    _klineCurrentListSubject?.close();
    _klineListSubject.close();
    _klineListSubjectSink.close();
  }

  initState() {
    candlestickWidth = configuration.kCandlestickWidth;
    initBase();
  }

  _initBlock() {
    _klineListSubject = StreamController<List<Market>>.broadcast();
    _klineListSubjectSink = _klineListSubject.sink;
    klineListSubjectStream = _klineListSubject.stream;
    _klineCurrentListSubject = StreamController<List<Market>>.broadcast();
    _currentKlineListSink = _klineCurrentListSubject.sink;
    currentKlineListStream = _klineCurrentListSubject.stream;
  }

  initSize(double w, double h) {
    width = w;
    height = h;
  }

  initConf(KlineConfiguration c) {
    configuration = c;
  }

  initBase() {
    _initBlock();
    _getSingleScreenCandleCount();
    _handlerSetFirstShow();
  }

  /// 数据处理
  updateDataList(List<Market> dataList) {
    if (dataList != null) {
      klineTotalList.clear();
      klineTotalList.addAll(
        KlineDataManager.calculateKlineData(YKChartType.MA, dataList),
      );
      _klineListSubjectSink.add(klineTotalList);

      getSubKlineList();
    }
  }

  ///设置kbox
  void setKBox(Size size) {
    ///计算出烛台占比
    candleHeightAverage =
        (size.height - globalKlineBloc.configuration.kTopMargin) /
            (priceMax - priceMin);
  }

  /// 屏幕显示的柱状最大数量
  _getSingleScreenCandleCount() {
    int count = (width + configuration.kCandlestickGap) ~/
        (candlestickWidth + configuration.kCandlestickGap);
    screenCandleCount = count;
  }

  ///第一次留一个column不画 显示的是价格
  double _getFirstScreenScale() {
    return (configuration.kGridColumnCount - 1) /
        configuration.kGridColumnCount;
  }

  ///设置首屏展示
  _handlerSetFirstShow() {
    firstScreenCandleCount =
        (_getFirstScreenScale() * screenCandleCount).toInt();
    columnGap = width / configuration.kGridColumnCount;
  }

  ///increase 偏移量
  void getSubKlineList({int increase, bool isScale = false}) {
    if (increase != null) {
      this.increase = increase;
    }
    if (isScale) {
      handlerScaleShow();
    } else {
      _handlerSubFromAndTo();
    }

    debugPrint("++ getSubKlineList from:$fromIndex to:$toIndex len:" +
        klineTotalList.length.toString() +
        'firstScreenCandleCount:$firstScreenCandleCount' +
        'screenCandleCount:$screenCandleCount');

    klineCurrentList.clear();

    klineCurrentList = klineTotalList.sublist(fromIndex, toIndex);
    _calculateCurrentKlineDataLimit();
    _currentKlineListSink?.add(klineCurrentList);
  }

  ///正常计算from和to 通过偏移量去计算
  void _handlerSubFromAndTo() {
    /// 当前数据没有超出一屏
    if (firstScreenCandleCount + increase < screenCandleCount) {
      toIndex = klineTotalList.length;
      if (toIndex - increase - firstScreenCandleCount > 0) {
        fromIndex = toIndex - increase - firstScreenCandleCount;
      } else {
        fromIndex = 0;
      }
      isFull = (toIndex - fromIndex) / screenCandleCount;
    } else {
      isFull = 1.0;

      /// 需要移动的数量
      int dis = firstScreenCandleCount + increase - screenCandleCount;
      if (klineTotalList.length - dis > 0) {
        toIndex = klineTotalList.length - dis;
      } else {
        toIndex = klineTotalList.length;
      }

      if (toIndex - screenCandleCount > 0) {
        fromIndex = toIndex - screenCandleCount;
      } else {
        fromIndex = 0;
      }
    }
  }

  ///缩放计算from to
  void handlerScaleShow() {
    if (screenCandleCount > klineTotalList.length) {
      this.fromIndex = 0;
      return;
    }
    if (isFull == 1.0) {
      fromIndex = toIndex - screenCandleCount;
    } else {
      fromIndex = (toIndex - screenCandleCount * isFull).toInt();
    }
    if (fromIndex <= 0) {
      fromIndex = 0;
    }
    if (fromIndex >= klineTotalList.length) {
      fromIndex = screenCandleCount;
    }
  }

  ///计算最大最小price 以及vol
  void _calculateCurrentKlineDataLimit() {
    double _priceMax = -double.infinity;
    double _priceMin = double.infinity;
    double _pMax = -double.infinity;
    double _pMin = double.infinity;
    double _volumeMax = -double.infinity;
    for (var item in klineCurrentList) {
      _volumeMax = max(item.vol, _volumeMax);

      _priceMax = max(_priceMax, item.high.toDouble());
      _priceMin = min(_priceMin, item.low.toDouble());

      _pMax = max(_pMax, item.high.toDouble());
      _pMin = min(_pMin, item.low.toDouble());

      /// 与x日均线数据对比计算最高最低价格
      if (item.priceMa1 != null) {
        _priceMax = max(_priceMax, item.priceMa1);
        _priceMin = min(_priceMin, item.priceMa1);
      }
      if (item.priceMa2 != null) {
        _priceMax = max(_priceMax, item.priceMa2);
        _priceMin = min(_priceMin, item.priceMa2);
      }
      if (item.priceMa3 != null) {
        _priceMax = max(_priceMax, item.priceMa3);
        _priceMin = min(_priceMin, item.priceMa3);
      }

      if (item.volMa1 != null) {
        _volumeMax = max(_volumeMax, item.volMa1);
      }

      if (item.volMa2 != null) {
        _volumeMax = max(_volumeMax, item.volMa2);
      }
      pMax = _pMax;
      pMin = _pMin;
      priceMax = _priceMax;
      priceMin = _priceMin;
      volumeMax = _volumeMax;
    }
  }

  void setCandlestickWidth(double scaleWidth) {
    if (scaleWidth > globalKlineBloc.configuration.kCandlestickWidthMax ||
        scaleWidth < globalKlineBloc.configuration.kCandlestickWidthMin) {
      return;
    }
    candlestickWidth = scaleWidth;

    ///缩放跳转总数
    _getSingleScreenCandleCount();

    _handlerSetFirstShow();
  }
}
