import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewV extends StatelessWidget {
  final String baseUrl;
  final Function change;

  WebViewV(this.baseUrl, {this.change});

  @override
  Widget build(BuildContext context) {
    WebViewController controller;
    return WebView(
      initialUrl: baseUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        controller = webViewController;
      },

      // 注册方法给js调用
      javascriptChannels: <JavascriptChannel>[
        _toasterJavascriptChannel(context),
      ].toSet(),

      // h5页面跳转拦截
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },

      onPageStarted: (String url) {
        print('Page started loading: $url');
      },

      onPageFinished: (String url) {
        print('Page finished loading: $controller');
        controller.evaluateJavascript("document.title").then((String value) {
          change(value);
        });
      },

      gestureNavigationEnabled: true,
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
