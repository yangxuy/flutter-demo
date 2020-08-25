import 'package:flutter/material.dart';

class InheritedProvider<T> extends InheritedWidget {
  final T data;

  InheritedProvider({@required this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class Consumer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T value) builder;

  Consumer(this.builder);

  @override
  Widget build(BuildContext context) {
    return builder(context, ChangeNotifierProvider.of<T>(context));
  }
}

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final T data;

  ChangeNotifierProvider({this.data, this.child});

  static T of<T>(BuildContext context, {bool listen = true}) {
    InheritedProvider<T> provider = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>()
        : context.getElementForInheritedWidgetOfExactType();
    return provider.data;
  }

  @override
  _ChangeNotifierProviderState createState() => _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState extends State<ChangeNotifierProvider> {
  @override
  void initState() {
    super.initState();
    widget.data.addListener(update);
  }

  void update() {
    setState(() {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<ChangeNotifier> oldWidget) {
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ListView;
    return InheritedProvider(
      child: widget.child,
      data: widget.data,
    );
  }
}
