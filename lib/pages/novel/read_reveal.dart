import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'package:yx_demo/screen/screen.dart';

import 'novel_mc.dart';

class PageReveal extends StatelessWidget {
  final Widget child;

  PageReveal({this.child});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      value: Provider.of<NovelMC>(context),
      builder: (_, NovelMC mc, __) {
        return Transform(
          transform:
              Matrix4.translationValues(-mc.slidePercent * Screen.width, 0, 0),
          child: Transform(
            transform: Matrix4.rotationY(0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: Offset(4, 4),
                    blurRadius: 4)
              ]),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
