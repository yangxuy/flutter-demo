import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yx_demo/main_mc.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';

class LanguageMC extends BaseModelLogic {
  changeLocal(Locale locale) {
    Provider.of<MainMC>(context, listen: true).changeLocale(locale);
  }

  changeLanguage() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('修改语言'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              FlatButton(
                child: Text('中文'),
                onPressed: () {
                  changeLocal(Locale('zh', 'CN'));
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('英文'),
                onPressed: () {
                  changeLocal(Locale('en', 'US'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
