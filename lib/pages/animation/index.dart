import 'package:flutter/material.dart';
import 'package:yx_demo/page_config/base_page.dart';

import 'animation_mc.dart';

class AnimationIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<AnimationMC>(
      create: (_) => AnimationMC()..attach(context),
      builder: (_, AnimationMC mc, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('动画'),
          ),
          body: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                FlatButton(
                  child: Text('重启动画'),
                  onPressed: () {
                    if (mc.controller.status == AnimationStatus.completed) {
                      mc.controller.reverse();
                    } else {
                      mc.controller.forward();
                    }
                  },
                ),
                AnimatedBuilder(
                  animation: mc.animation,
                  builder: (BuildContext context, Widget child) {
                    return Container(
                      height: mc.animation.value,
                      color: Colors.red,
                      child: Text('测试'),
                    );
                  },
                ),
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: Colors.yellow,
                    ),
                    Positioned(
                      bottom: -20,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
