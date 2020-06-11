import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo2/page_config/base_model_logic.dart';
import 'package:demo2/route_config/pop_route/index.dart';

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
