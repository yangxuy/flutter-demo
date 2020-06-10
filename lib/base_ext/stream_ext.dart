import 'dart:async';
import 'package:demo2/http/http.dart';
import 'package:demo2/page_config/base_model_logic.dart';
import 'package:flutter/foundation.dart';

import 'model_ext.dart';

extension StreamExt<T> on Stream<T> {
  /// 添加流的自动关闭：推出页面残留的stream将自动关闭
  Stream<T> autoDisposed(BaseModelLogic model, [VoidCallback onDisposed]) {
    return transform(StreamTransformer<T, T>((Stream<T> input, bool cancelOnError) {
      StreamController<T> controller;
      StreamSubscription<T> subscription;

      controller = StreamController<T>(
          sync: true,
          onListen: () {
            subscription = input.listen(
              (value) {
                controller.add(value);
              },
              onError: controller.addError,
              onDone: controller.close,
              cancelOnError: cancelOnError,
            );
            model.addStreamSubscription(subscription);
            if (onDisposed != null) {
              model.addOnDisposedCallback(onDisposed);
            }
          },
          onPause: ([Future<dynamic> resumeSignal]) => subscription.pause(resumeSignal),
          onResume: () => subscription.resume(),
          onCancel: () => subscription.cancel());

      return controller.stream.listen(null);
    }));
  }

  /// 添加流的拦截比如在http请求的时候 添加弹窗
  Stream<T> autoDialog(LoadingModel model) {
    return transform(StreamTransformer<T, T>((Stream<T> input, bool cancelOnError) {
      StreamController<T> controller;
      StreamSubscription<T> subscription;

      /// 在http的时候 才添加弹窗
      if (T is ResultData) {
        model.showDialog();
      }
      model.showDialog();
      controller = StreamController<T>(
          sync: true,
          onListen: () {
            subscription = input.listen(
              (value) {
                model.closeDialog();
                controller.add(value);
              },
              onError: controller.addError,
              onDone: controller.close,
              cancelOnError: cancelOnError,
            );
          },
          onPause: ([Future<dynamic> resumeSignal]) => subscription.pause(resumeSignal),
          onResume: () => subscription.resume(),
          onCancel: () => subscription.cancel());
      return controller.stream.listen(null);
    }));
  }
}
