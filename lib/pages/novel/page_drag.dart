import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yx_demo/page_config/base_page.dart';

import 'novel_mc.dart';
import 'type.dart';

class PageDrag extends StatelessWidget {
  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  double slidePercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      value: Provider.of<NovelMC>(context),
      builder: (_, NovelMC mc, __) {
        return GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            onDragStart(mc, details);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            onDragUpdate(mc, details);
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            onDragEnd(mc, details);
          },
        );
      },
    );
  }

  onDragStart(NovelMC mc, DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(NovelMC mc, DragUpdateDetails details) {
    if (dragStart != null) {
      print('${dragStart.dx}-------开始');
      print('${details.globalPosition.dx}-------结束');
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0) {
        mc.slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0) {
        mc.slideDirection = SlideDirection.leftToRight;
      } else {
        mc.slideDirection = SlideDirection.none;
      }

      if (mc.slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      print('$slidePercent -----------');
      mc.slideUpdateStream.sink.add(
          SlideUpdate(UpdateType.dragging, mc.slideDirection, slidePercent));
    }
  }

  onDragEnd(NovelMC mc, DragEndDetails details) {
    mc.slideUpdateStream.sink.add(SlideUpdate(
      UpdateType.doneDragging,
      SlideDirection.none,
      0.0,
    ));
  }
}
