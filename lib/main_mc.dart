import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';
import 'dart:io';

class MainMC extends BaseModelLogic {
  Locale locale = Locale('zh', 'CN');
  GlobalKey materialAppKey = GlobalKey();

  ThemeData themeData = ThemeData(
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
            headline6: TextStyle(
                fontSize: 18
            ))),
  );

  setTheme(int type) {
    switch (type) {
      case 0:
        themeData = ThemeData(
          primaryColor: Colors.red,
          appBarTheme: AppBarTheme(
              color: Colors.red,
              textTheme: TextTheme(
                  headline6: TextStyle(color: Colors.white, fontSize: 18))),
        );
        break;
      case 1:
        themeData = ThemeData(
          primaryColor: Colors.blue,
          appBarTheme: AppBarTheme(
              color: Colors.blue,
              textTheme: TextTheme(
                  headline6: TextStyle(
                      color: Colors.red,
                      fontSize: 18
                  ))),
        );
        break;
    }
    notify();
  }

  changeLocale(Locale v) {
    locale = v;
    notify();
  }
}
