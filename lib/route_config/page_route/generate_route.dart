import 'package:demo2/pages/home/home_page.dart';
import 'package:demo2/pages/login/login.dart';
import 'package:demo2/pages/main.dart';
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
    default:
      return SlideFromRightPageBuilder(LoginPage(), settings: settings);
  }
}
