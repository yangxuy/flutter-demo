import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model_logic.dart';

typedef ValueLogicWidgetBuilder<T extends BaseModelLogic> = Widget Function(
    BuildContext context, T provider, Widget child);

class BasePage<T extends BaseModelLogic> extends StatelessWidget {
  final ValueLogicWidgetBuilder<T> builder;
  final Create<T> create;
  final T value;
  final Widget child;

  BasePage({this.builder, this.create, this.child, this.value});

  Widget logicBuilder(BuildContext context, T provider, Widget child) {
    return builder(context, provider, child);
  }

  @override
  Widget build(BuildContext context) {
    if (create != null) {
      return ChangeNotifierProvider<T>(
        create: create,
        child: Consumer<T>(
          child: child,
          builder: logicBuilder,
        ),
      );
    }

    if (value != null) {
      return ChangeNotifierProvider<T>.value(
        value: value,
        child: Consumer<T>(
          child: child,
          builder: logicBuilder,
        ),
      );
    }

    return null;
  }
}
