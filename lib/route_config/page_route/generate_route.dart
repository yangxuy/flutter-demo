import 'package:yx_demo/pages/animation/index.dart';
import 'package:yx_demo/pages/canvas/index.dart';
import 'package:yx_demo/pages/cartoon/cartoon.dart';
import 'package:yx_demo/pages/document/down.dart';
import 'package:yx_demo/pages/home/home_page.dart';
import 'package:yx_demo/pages/index.dart';
import 'package:yx_demo/pages/language/index.dart';
import 'package:yx_demo/pages/login/login.dart';
import 'package:yx_demo/pages/main.dart';
import 'package:yx_demo/pages/novels/novel.dart';
import 'package:yx_demo/pages/novel/drag_novel.dart';
//import 'package:yx_demo/pages/novel/index.dart';
//import 'package:yx_demo/pages/reader/reader_scene.dart';
import 'package:yx_demo/pages/reveal/index.dart';
import 'package:yx_demo/pages/scroll_page/scroll_page.dart';
import 'package:yx_demo/pages/swiper/swiper.dart';
import 'package:flutter/material.dart';

import 'index.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeInPageBuilder(MainPage(), settings: settings);
    case '/login':
      return SlideFromBottomPageBuilder(LoginPage(), settings: settings);
    case '/home':
      return SlideFromRightPageBuilder(HomePage(), settings: settings);
    case '/down':
      return SlideFromBottomPageBuilder(
          Down(
            webUrl: settings.arguments,
          ),
          settings: settings);
    case '/carousel':
      return SlideFromRightPageBuilder(Carousel(), settings: settings);
    case '/int':
      return SlideFromRightPageBuilder(Language(), settings: settings);
    case '/animation':
      return SlideFromRightPageBuilder(AnimationIndex(), settings: settings);
    case '/canvas':
      return SlideFromRightPageBuilder(CanvasIndex(), settings: settings);
    case '/novel':
      return SlideFromRightPageBuilder(Novel(), settings: settings);
    case '/cartoon':
      return SlideFromRightPageBuilder(Cartoon(), settings: settings);
    case '/systemChrome':
      return SlideFromRightPageBuilder(SystemChromePage(), settings: settings);
    case '/pageReveal':
      return SlideFromRightPageBuilder(IndexReveal(), settings: settings);
    case '/scrollPage':
      return SlideFromRightPageBuilder(ScrollPage(), settings: settings);
    default:
      return SlideFromRightPageBuilder(LoginPage(), settings: settings);
  }
}
