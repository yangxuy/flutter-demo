import 'package:flutter/material.dart';

class IntLocalizations {
  bool isZh = false;

  IntLocalizations(this.isZh);

  //为了使用方便，我们定义一个静态方法
  static IntLocalizations of(BuildContext context) {
    return Localizations.of<IntLocalizations>(context, IntLocalizations);
  }

  //Locale相关值，title为应用标题
  String get title {
    return isZh ? "Flutter应用" : "Flutter APP";
  }

  //Locale相关值，content显示内容
  String get content {
    return isZh ? "这里是测试内容" : "this is test word";
  }
}
