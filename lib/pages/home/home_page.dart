import 'package:demo2/page_config/base_page.dart';
import 'package:flutter/material.dart';

import 'home_model_logic.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: BasePage(
        create: (_) => HomeModelLogic()..attach(context),
        builder: (_, HomeModelLogic logic, child) {
          return Column(
            children: <Widget>[Text('首页测试')],
          );
        },
      ),
    );
  }
}
