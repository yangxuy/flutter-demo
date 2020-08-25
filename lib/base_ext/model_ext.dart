import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';
import 'package:yx_demo/route_config/pop_route/index.dart';
import 'package:flutter/scheduler.dart';

/// 扩展BaseModelLogic 添加弹窗
mixin LoadingModel on BaseModelLogic {
  showDialog() {
    ShowPopupPage.showPopupPage(
      context,
      barrierLabel: 'loading',
      dismissible: true,
      child: Center(
        child: Material(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.white,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  closeDialog() {
    ShowPopupPage.closePopupPage(context);
  }
}

mixin  SingleTickerProviderModelMixin on BaseModelLogic implements TickerProvider{
  Ticker _ticker;
  @override
  Ticker createTicker(TickerCallback onTick){
    _ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
    return _ticker;
  }
}