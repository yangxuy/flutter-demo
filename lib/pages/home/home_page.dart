import 'package:yx_demo/page_config/base_page.dart';
import 'package:flutter/material.dart';

import 'home_model_logic.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      create: (_) => HomeModelLogic()..attach(context),
      builder: (_,HomeModelLogic p,__){
        return Scaffold(
          appBar: AppBar(
            title: Text('首页'),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.add), onPressed: p.showOverLay)
            ],
          ),
          body:SingleChildScrollView(
            child: p.buildPanel(),
          ),
        );
      },
    );
  }
}
