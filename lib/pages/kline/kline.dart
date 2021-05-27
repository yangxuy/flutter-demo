import 'package:flutter/material.dart';
import 'package:kline/kline.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'kline_logic.dart';

class KLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<KlineLogic>(
      create: (_) => KlineLogic()..attach(context),
      builder: (BuildContext context, provider, Widget child) {
        provider.klineBloc.initSize(MediaQuery.of(context).size.width, 300);

        return Scaffold(
          appBar: AppBar(
            title: Text('k线'),
          ),
          body: KLineView(
            klineBloc: provider.klineBloc,
          ),
        );
      },
    );
  }
}
