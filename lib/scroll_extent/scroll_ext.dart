import 'package:flutter/material.dart';
import 'package:yx_demo/scroll_extent/position_ext.dart';

class XScrollController extends ScrollController{

  ScrollPosition createScrollPosition(
      ScrollPhysics physics,
      ScrollContext context,
      ScrollPosition oldPosition,
      ) {
    return XScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}