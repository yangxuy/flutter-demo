import 'package:flutter/material.dart';

class CCInheritedProvider<T> extends InheritedWidget {
  CCInheritedProvider({this.data, Widget child}) : super(child: child);

  final T data;

  @override
  bool updateShouldNotify(CCInheritedProvider oldWidget) {
    // 每次更新都会刷新
    return true;
  }
}

class XXChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  XXChangeNotifierProvider({
    Key key,
    this.data,
    this.child,
  }) : super(key: key);

  final Widget child;
  final T data;

  //添加一个listen参数，表示是否建立依赖关系
  static T of<T>(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<CCInheritedProvider<T>>()
        : context
            .getElementForInheritedWidgetOfExactType<CCInheritedProvider<T>>()
            ?.widget as CCInheritedProvider<T>;
    return provider?.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() => _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<XXChangeNotifierProvider<T>> {
  void update() {
    // 如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(XXChangeNotifierProvider<T> oldWidget) {
    // 当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CCInheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  Consumer({
    Key key,
    @required this.builder,
    this.child,
  })  : assert(builder != null),
        super(key: key);

  final Widget child;

  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      XXChangeNotifierProvider.of<T>(context), //自动获取Model
    );
  }
}