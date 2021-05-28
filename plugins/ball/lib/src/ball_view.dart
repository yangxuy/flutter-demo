import 'package:flutter/material.dart';
import 'inherited_provider.dart';
import 'ball_manager.dart';
import 'ball_draw.dart';

class Ball extends StatelessWidget {
  final BallManager data;

  Ball({this.data});

  @override
  Widget build(BuildContext context) {
    return XXChangeNotifierProvider<BallManager>(
      data: data,
      child: Consumer<BallManager>(
        builder: (BuildContext context, BallManager vm) {
          if (vm.conf.indicatorColor == null)
            vm.conf.indicatorColor = Theme.of(context).indicatorColor;
          if (vm.conf.selectedIndicatorColor == null)
            vm.conf.selectedIndicatorColor =
                vm.conf.indicatorColor.withAlpha(0xB2);
          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: vm.handlerPointDown,
            onPointerMove: vm.handlerPointMove,
            onPointerUp: vm.handlerPointUp,
            onPointerCancel: vm.handlerPointCancel,
            child: ClipOval(
              child: CustomPaint(
                size: Size(
                  2.0 * vm.conf.radius,
                  2.0 * vm.conf.radius,
                ),
                painter: BallDraw(manager: vm),
              ),
            ),
          );
        },
      ),
    );
  }
}
