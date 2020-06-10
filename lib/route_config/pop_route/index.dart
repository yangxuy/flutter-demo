import 'package:flutter/material.dart';

import 'popup_builder.dart';

class ShowPopupPage {
  static bool _isDismissible = false;

  static showGeneralPopupPage(context,{Widget child}) {
    showGeneralDialog(
      context: context,
      barrierLabel: '测试',
      barrierDismissible: true,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
      transitionDuration: Duration(microseconds: 300),
      pageBuilder: (_, __, ___) {
        return child;
      },
    );
  }

  static showPopupPage<T>(
    BuildContext context, {
    Widget child,
    Duration duration = const Duration(microseconds: 300),
    Color barrierColor = const Color.fromRGBO(0, 0, 0, 0.5),
    bool dismissible = true,
    RouteTransitionsBuilder transitionBuilder,
    String barrierLabel,
  }) async {
    if (!_isDismissible) {
      _isDismissible = true;
      T res = await Navigator.push<T>(
          context,
          PopupRouteBuilder<T>(
              child: child,
              duration: duration,
              barrier: barrierColor,
              dismissible: dismissible,
              transitionBuilder: transitionBuilder,
              label: barrierLabel));
      _isDismissible = false;
      return res;
    }
  }

  static closePopupPage(
    BuildContext context,
  ) {
    if (_isDismissible) {
      Navigator.of(context).pop();
      _isDismissible = false;
    }
  }
}
