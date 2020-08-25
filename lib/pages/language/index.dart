import 'package:flutter/material.dart';
import 'package:yx_demo/int/int_resource.dart';
import 'package:yx_demo/page_config/base_page.dart';

import 'language_mc.dart';

class Language extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<LanguageMC>(
      create: (_) => LanguageMC()..attach(context),
      builder: (_, LanguageMC mc, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(IntLocalizations.of(context).title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(IntLocalizations.of(context).content),
                RaisedButton(
                  child: Text('修改系统语言'),
                  onPressed:mc.changeLanguage,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
