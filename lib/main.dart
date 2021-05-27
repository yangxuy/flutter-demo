import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'package:yx_demo/pages/index.dart';
import 'int/int_delegate.dart';
import 'main_mc.dart';
import 'route_config/page_route/generate_route.dart';

void main() {
  runApp(DemoApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<MainMC>(
      create: (_) => MainMC()..attach(context),
      builder: (_, MainMC mc, __) {
        return MaterialApp(
          theme: ThemeData(
              // primaryColor: Colors.white
              ),
          onGenerateRoute: onGenerateRoute,
          key: mc.materialAppKey,
//          theme: mc.themeData,
          localizationsDelegates: [
            IntLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          locale: mc.locale,
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('zh', 'CN'),
          ],
        );
      },
    );
  }
}
