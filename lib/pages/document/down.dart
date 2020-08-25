import 'package:flutter/material.dart';
import 'package:yx_demo/commont/widget/webview.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'package:yx_demo/pages/document/down_mc.dart';

class Down extends StatelessWidget {
  final String webUrl;

  Down({this.webUrl});

  @override
  Widget build(BuildContext context) {
    return BasePage<DownMC>(
      create: (_) => DownMC()..attach(context),
      builder: (_, DownMC mc, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(mc.title),
          ),
          body: WebViewV(
            webUrl,
            change: (String event) {
              mc.changeTitle(event);
            },
          ),
        );
      },
    );
  }
}
