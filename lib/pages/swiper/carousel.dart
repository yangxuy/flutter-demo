import 'package:flutter/material.dart';
import 'package:yx_demo/page_config/base_page.dart';

import 'CustomPageView.dart';
import 'carousel_mc.dart';

class Carousel extends StatelessWidget {
  final double aspectRatio;
  final double viewportFraction;

  Carousel({this.aspectRatio = 2.5, this.viewportFraction = 1.0});

  @override
  Widget build(BuildContext context) {
    return BasePage<CarouselMC>(
      create: (_) => CarouselMC()
        ..attach(_, arguments: {
          "aspectRatio": aspectRatio,
          "viewportFraction": viewportFraction
        }),
      builder: (_, CarouselMC mc, __) {
        return AspectRatio(
          aspectRatio: mc.aspectRatio,
          child: NotificationListener(
            onNotification: (Notification notification) {
              return true;
            },
            child: CustomPageView(
              physics: BouncingScrollPhysics(),
              controller: mc.controller,
              onPageChanged: (page) {
              },
              children: [],
            ),
          ),
        );
      },
    );
  }
}
