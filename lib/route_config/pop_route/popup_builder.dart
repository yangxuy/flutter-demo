import 'package:flutter/material.dart';

/// 构建popuprouterBuilder
class PopupRouteBuilder<T> extends PopupRoute<T> {
  final Widget child;
  final Duration duration;
  final Color barrier;
  final bool dismissible;
  final String label;
  final RouteTransitionsBuilder transitionBuilder;

  PopupRouteBuilder({
    @required this.child,
    this.duration,
    this.barrier,
    this.dismissible,
    this.transitionBuilder,
    this.label,
  });

  @override
  Color get barrierColor => barrier;

  @override
  bool get barrierDismissible => this.dismissible;

  @override
  String get barrierLabel => label ?? null;

  @override
  Duration get transitionDuration => this.duration;

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    }
    return transitionBuilder(context, animation, secondaryAnimation, child);
  }
}
