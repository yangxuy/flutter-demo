import 'package:flutter/material.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'package:ball/ball.dart';
import 'ball_logic.dart';

class BallView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      create: (_) => KlineLogic()..attach(context),
      builder: (_, KlineLogic logic, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('ball'),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                child: Image.asset(
                  "images/symptom_light@3x.png",
                  width: 260,
                  height: 260,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/symptom_ballwithflare@3x.png",
                        fit: BoxFit.fill,
                      ),
                      Ball(
                        data: logic.pm,
                      )
                    ],
                  ),
                  Image.asset(
                    "images/symptom_ball_shadow@3x.png",
                    width: 260,
                    height: 20,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
