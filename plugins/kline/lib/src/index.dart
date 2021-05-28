import 'package:flutter/material.dart';
import '../kline.dart';
import 'children/candle.dart';
import 'children/grid.dart';
import 'children/scroll.dart';
import 'children/time.dart';
import 'children/volume.dart';

/// 全局的bloc
KlineBloc globalKlineBloc;

class KLineView extends StatefulWidget {
  final KlineBloc klineBloc;

  KLineView({this.klineBloc});

  @override
  _KLineViewState createState() => _KLineViewState();
}

class _KLineViewState extends State<KLineView> {
  @override
  void initState() {
    super.initState();
    globalKlineBloc = widget.klineBloc;
    globalKlineBloc.initState();
  }

  @override
  void dispose() {
    super.dispose();
    globalKlineBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: globalKlineBloc.width,
      height: globalKlineBloc.height,
      color: Color(0xff101B2D),
      child: Stack(
        children: [
          Column(
            children: [
              ///k线
              Expanded(
                child: Stack(
                  children: [
                    GridWidget(),
                    CandleWidget(),
                  ],
                ),
                flex: 7,
              ),

              /// 时间
              Expanded(child: TimeWidget(), flex: 1),

              /// 交易量
              Expanded(
                child: Stack(
                  children: [
                    /// 网格
                    GridWidget(
                      isTop: false,
                    ),

                    ///交易量烛台
                    VolumeWidget(),
                  ],
                ),
                flex: 2,
              ),
            ],
          ),

          ///事件
          ScrollWidget(),
        ],
      ),
    );
  }
}
