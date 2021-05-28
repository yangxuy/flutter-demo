import 'package:yx_demo/pages/ball/index.dart';
import 'package:yx_demo/pages/home/home_page.dart';
import 'package:yx_demo/pages/kline/kline.dart';
import 'package:yx_demo/pages/main.dart';
import 'package:yx_demo/pages/novels/novel.dart';
import 'package:flutter/material.dart';

import 'index.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeInPageBuilder(MainPage(), settings: settings);
    case '/home':
      return SlideFromRightPageBuilder(HomePage(), settings: settings);
    case '/novel':
      return SlideFromRightPageBuilder(Novel(), settings: settings);
    case '/ball':
      return SlideFromRightPageBuilder(BallView(), settings: settings);
    case '/kline':
      return SlideFromRightPageBuilder(KLine(), settings: settings);
  }
}
