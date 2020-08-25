import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class BaseBloc {
  initState();
  dispose();
}


mixin  SingleTickerProviderModelMixin on BaseBloc implements TickerProvider{
  Ticker _ticker;
  @override
  Ticker createTicker(TickerCallback onTick){
    _ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
    return _ticker;
  }
}

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({@required this.bloc, @required this.child, Key key})
      : super(key: key);

  @override
  _BlocProviderState createState() => _BlocProviderState();

  static of<T extends BaseBloc>(BuildContext context) {
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  void initState() {
    super.initState();
    widget.bloc.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }
}
