import 'package:demo2/page_config/base_page.dart';
import 'package:demo2/pages/main_logic.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePage(
        create: (_) => MainModelLogic()..attach(context),
        builder: (_, MainModelLogic logic, child) {
          return Container(
            child: Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: logic.goHome,
                      child: Text('home'),
                    ),
                    RaisedButton(
                      onPressed: logic.goLogin,
                      child: Text('login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
