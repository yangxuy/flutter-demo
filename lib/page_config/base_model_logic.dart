import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseModelLogic extends ChangeNotifier {
  BuildContext context;

  /// 存放流的订阅者
  final Map<BuildContext, CompositeSubscription> _compositeSubscriptionMap = HashMap();

  CompositeSubscription get _compositionSubscription => _compositeSubscriptionMap[context];

  /// 存放disposed回调
  final Map<BuildContext, Set<VoidCallback>> _onDisposedCallbackSets = HashMap();

  Set<VoidCallback> get _onDisposedCallbackSet => _onDisposedCallbackSets[context];

  /// 添加流的订阅者
  /// 用于自动释放流
  /// 通常直接调用 [StreamExtension]中的[autoDisposed]即可
  addStreamSubscription(StreamSubscription subscription) {
    _compositionSubscription.add(subscription);
  }

  /// 添加onDisposed回调
  /// 用于自动取消订阅Socket等
  /// 通常直接调用 [StreamExtension]中的[autoDisposed]即可
  void addOnDisposedCallback(VoidCallback callback) {
    _onDisposedCallbackSet.add(callback);
  }

  attach(BuildContext context,{dynamic arguments}) {
    _compositeSubscriptionMap[context] = CompositeSubscription();
    _onDisposedCallbackSets[context] = Set();
    this.context = context;
    init(arguments ?? ModalRoute.of(context)?.settings?.arguments);
  }

  /// 初始化可能需要
  init(dynamic arguments){

  }

  notify() {
    notifyListeners();
  }

  T read<T>() {
    return context.read<T>();
  }

  T watch<T>() {
    return context.watch<T>();
  }

  @override
  void dispose() {
    _compositionSubscription.dispose();
    _compositionSubscription.clear();
    if (_onDisposedCallbackSet != null) {
      _onDisposedCallbackSet.forEach((f) => f());
    }
    super.dispose();
  }
}

/// rxdart
class CompositeSubscription {
  bool _isDisposed = false;

  final List<StreamSubscription<dynamic>> _subscriptionsList = [];

  bool get isDisposed => _isDisposed;

  StreamSubscription<T> add<T>(StreamSubscription<T> subscription) {
    if (isDisposed) {
      throw ('This composite was disposed, try to use new instance instead');
    }
    _subscriptionsList.add(subscription);
    return subscription;
  }

  void remove(StreamSubscription<dynamic> subscription) {
    subscription.cancel();
    _subscriptionsList.remove(subscription);
  }

  void clear() {
    _subscriptionsList.forEach((StreamSubscription<dynamic> subscription) => subscription.cancel());
    _subscriptionsList.clear();
  }

  void dispose() {
    clear();
    _isDisposed = true;
  }
}
